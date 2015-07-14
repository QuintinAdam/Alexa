class Messenger

  attr_accessor :client

  def initialize
    account_sid = ENV["TWILIO_SECRET"]
    auth_token = ENV["TWILIO_TOKEN"]
    @client = Twilio::REST::Client.new account_sid, auth_token
  end

  def message(body, to = '+14074431720', from = '+14074431720')
    @client.account.messages.create(
      from: from,
      to: to,
      body: body
    )
  end

  def picture_message(body, media_url = nil,  to = '+14074431720', from = '+14074431720')
    @client.account.messages.create(
      from: from,
      to: to,
      body: body,
      media_url: media_url
    )
  end
end

