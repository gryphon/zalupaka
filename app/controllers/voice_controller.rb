class VoiceController < ApplicationController

  FOLDER = "b1gp1ppp4c3ptccck86u"

  layout false
  
  skip_before_action :verify_authenticity_token

  def voice

  end

  def generate

    phrase = request["text"]
    folder = Rails.configuration.yandex_folder.to_s

    text = Voice.generate(phrase)

    curl = Curl::Easy.new("https://tts.api.cloud.yandex.net/speech/v1/tts:synthesize")
    curl.headers["Authorization"] = "Bearer #{User.iam_token}"
    curl.post_body="voice=zahar&fornat=oggopus&emotion=good&folderId=#{folder}&text="+URI.escape(text)
    curl.http_post


    send_data curl.body_str, type: "audio/ogg", disposition: 'inline'

  end

  def recognize

    file = request["data"].read
    folder = Rails.configuration.yandex_folder.to_s
    #file = File.new("#{Rails.root}/app/speech.ogg", "rb").read

    curl = Curl::Easy.new("https://stt.api.cloud.yandex.net/speech/v1/stt:recognize/?topic=general&folderId=#{folder}")
    curl.headers["Authorization"] = "Bearer #{User.iam_token}"
    curl.post_body=file
    curl.http_post

    response = JSON.parse(curl.body_str)

    text = response["result"]

    render plain: text

  end

end