class User < ActiveRecord::Base

  @@iam_token = nil

  def self.refresh_iam_token

    curl = Curl::Easy.new("https://iam.api.cloud.yandex.net/iam/v1/tokens")
    curl.headers["Content-Type"] = "application/json"
    curl.post_body = '{"yandexPassportOauthToken": "'+Rails.configuration.yandex_oauth_token.to_s+'"}'
    result = curl.http_post

    @@iam_token = JSON.parse(curl.body_str.to_s)["iamToken"].to_s
    @@iam_refreshed_at = Time.now 

    return @@iam_token

  end


  def self.iam_token

    if @@iam_token.blank? || @@iam_refreshed_at.blank? || (@@iam_refreshed_at+1.hour < Time.now)
      User.refresh_iam_token
    end

    return @@iam_token

  end

end
