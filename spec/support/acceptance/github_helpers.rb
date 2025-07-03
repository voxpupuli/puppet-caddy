# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'

# Miscellaneous Github helpers
module GithubHelpers
  class GithubApiError < StandardError; end

  # Get latest release in a repo using the Github API
  def self.latest_release(repo)
    return @latest_release if @latest_release

    github_token = ENV.fetch('GITHUB_TOKEN', nil)

    uri = URI("https://api.github.com/repos/#{repo}/releases/latest")
    request = Net::HTTP::Get.new(uri)
    request['User-Agent'] = 'Ruby'
    request['Accept'] = 'application/vnd.github+json'
    request['Authorization'] = "Bearer #{github_token}" if github_token

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    case response
    when Net::HTTPSuccess
      @latest_release = JSON.parse(response.body)['tag_name']
    else
      raise GithubApiError, "Unexpected Github API response [#{response.code}]: #{response.body}"
    end
  end
end
