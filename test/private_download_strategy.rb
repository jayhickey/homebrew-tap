# Run with: brew ruby test/private_download_strategy.rb
# No network and no real credentials. Verify the API and secret-redaction contract.
require_relative "../lib/private_github_release_download_strategy"

module GitHub::API
  class << self
    alias_method :original_credentials_for_simqueue_test, :credentials
    alias_method :original_open_rest_for_simqueue_test, :open_rest
    attr_accessor :simqueue_test_token, :simqueue_test_release, :simqueue_test_endpoint

    def credentials
      simqueue_test_token
    end

    def open_rest(endpoint, **_options)
      self.simqueue_test_endpoint = endpoint
      simqueue_test_release
    end
  end
end

url = "https://github.com/jayhickey/SimQueue/releases/download/v0.1.0-beta.1/simqueue-0.1.0-beta.1-macos-arm64.tar.gz"
strategy = SimqueuePrivateGitHubReleaseDownloadStrategy.new(url, "simqueue", "0.1.0-beta.1")
class << strategy
  attr_reader :download_arguments, :download_options
  def curl_download(*arguments, **options)
    @download_arguments = arguments
    @download_options = options
  end
end

begin
  GitHub::API.simqueue_test_token = "unit-test-placeholder-never-a-real-secret"
  GitHub::API.simqueue_test_release = {
    "assets" => [{ "name" => "simqueue-0.1.0-beta.1-macos-arm64.tar.gz",
                   "url" => "https://api.github.com/repos/jayhickey/SimQueue/releases/assets/123" }],
  }
  strategy.send(:_fetch, url: url, resolved_url: url, timeout: 30)
  raise "wrong metadata endpoint" unless GitHub::API.simqueue_test_endpoint.end_with?("/tags/v0.1.0-beta.1")
  raise "wrong asset" unless strategy.download_arguments.first.end_with?("/assets/123")
  raise "missing download format" unless strategy.download_arguments.include?("Accept: application/octet-stream")
  raise "missing redaction" unless strategy.download_options[:secrets] == [GitHub::API.simqueue_test_token]
  raise "unsafe redirect" if strategy.download_arguments.include?("--location-trusted")
  raise "missing HTTPS redirect restriction" unless strategy.download_arguments.include?("--proto-redir")

  GitHub::API.simqueue_test_token = nil
  begin
    strategy.send(:_fetch, url: url, resolved_url: url, timeout: 30)
    raise "missing credentials unexpectedly accepted"
  rescue CurlDownloadStrategyError => error
    raise "unhelpful credentials error" unless error.message.include?("repository contents read")
  end
  GitHub::API.simqueue_test_token = "unit-test-placeholder-never-a-real-secret"
  GitHub::API.simqueue_test_release["assets"].first["url"] = "https://example.com/steal-token"
  begin
    strategy.send(:_fetch, url: url, resolved_url: url, timeout: 30)
    raise "foreign API endpoint unexpectedly accepted"
  rescue CurlDownloadStrategyError
    # Host/repository allowlist must refuse this before download.
  end
  begin
    SimqueuePrivateGitHubReleaseDownloadStrategy.new("https://example.com/release.tar.gz", "simqueue", "0.1.0")
    raise "untrusted release URL unexpectedly accepted"
  rescue ArgumentError
    # Only this private repository receives credentials.
  end
  [
    "v0.1.0-beta.1/simqueue-0.1.0-beta.1-macos-universal.tar.gz",
    "v0.1.0-beta.1/simqueue-0.1.0-beta.1-macos-x86_64.tar.gz",
    "v0.1.0-beta.1/simqueue-0.1.0-beta.2-macos-arm64.tar.gz",
    "v0.1.0-beta.1/simqueue-0.1.0-beta.1-macos-arm64.tar.gz%3Ftoken=bad",
  ].each do |asset|
    begin
      SimqueuePrivateGitHubReleaseDownloadStrategy.new(
        "https://github.com/jayhickey/SimQueue/releases/download/#{asset}", "simqueue", "0.1.0-beta.1"
      )
      raise "unsupported architecture or mismatched asset unexpectedly accepted: #{asset}"
    rescue ArgumentError
      # Only the exact matching arm64 versioned asset is supported.
    end
  end
  puts "private release strategy: arm64 asset selection, secret redaction, errors and URL restrictions passed"
ensure
  class << GitHub::API
    alias_method :credentials, :original_credentials_for_simqueue_test
    alias_method :open_rest, :original_open_rest_for_simqueue_test
  end
end
