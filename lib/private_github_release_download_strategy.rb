# typed: false
# frozen_string_literal: true

require "download_strategy"
require "utils/github"
require "uri"

# Homebrew no longer ships GitHubPrivateRepositoryReleaseDownloadStrategy.
# Keep cache/locking/checksum behavior in CurlDownloadStrategy, and use the same
# credential discovery/redaction as Homebrew's GitHub Actions artifact downloader.
class SimqueuePrivateGitHubReleaseDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    match = %r{\Ahttps://github\.com/jayhickey/SimQueue/releases/download/([^/]+)/([^/?#]+)\z}.match(url)
    raise ArgumentError, "Expected a SimQueue GitHub release-asset URL" unless match

    @release_tag = URI.decode_www_form_component(match[1])
    @asset_name = URI.decode_www_form_component(match[2])
    asset = /\Asimqueue-([0-9][0-9A-Za-z.+-]*)-macos-arm64\.tar\.gz\z/.match(@asset_name)
    unless asset && @release_tag == "v#{asset[1]}"
      raise ArgumentError, "Expected an Apple Silicon SimQueue asset matching its versioned release tag"
    end
    super
  end

  private

  # The public download URL's HEAD request is unauthenticated and returns 404
  # for private repositories. The immutable versioned asset is checked by SHA-256.
  def resolve_url_basename_time_file_size(url, timeout: nil)
    [url, @asset_name, nil, nil, nil, false]
  end

  def _fetch(url:, resolved_url:, timeout:)
    token = GitHub::API.credentials
    if token.nil? || token.empty?
      raise CurlDownloadStrategyError.new(url, "Private beta access requires gh auth login or HOMEBREW_GITHUB_API_TOKEN with repository contents read access")
    end

    tag = URI.encode_www_form_component(@release_tag)
    release = GitHub::API.open_rest("https://api.github.com/repos/jayhickey/SimQueue/releases/tags/#{tag}")
    asset = release.fetch("assets", []).find { |entry| entry["name"] == @asset_name }
    api_url = asset && asset["url"]
    unless api_url && %r{\Ahttps://api\.github\.com/repos/jayhickey/SimQueue/releases/assets/\d+\z}.match?(api_url)
      raise CurlDownloadStrategyError.new(url, "Release asset is missing or inaccessible; check beta repository access and published version")
    end

    # libcurl strips Authorization on cross-host redirects. Never use
    # --location-trusted. Only HTTPS redirects are permitted. `secrets` redacts
    # the token from Homebrew debug/errors, matching its artifact downloader.
    curl_download api_url,
                  "--header", "Accept: application/octet-stream",
                  "--header", "Authorization: Bearer #{token}",
                  "--proto", "=https", "--proto-redir", "=https",
                  to: temporary_path, secrets: [token], timeout: timeout
  end
end
