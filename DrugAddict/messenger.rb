class Messenger
  require 'twilio-ruby'

  attr_accessor :client
  def initialize
    account_sid = ENV["TWILIO_SECRET"]
    auth_token = ENV["TWILIO_TOKEN"]
    @client = Twilio::REST::Client.new account_sid, auth_token
  end

  def message(body,  to = '+18019461510', from = '+18017520416')
    @client.account.messages.create(
      from: from,
      to: to,
      body: body
    )
  end

  def picture_message(body, media_url = nil,  to = '+18019461510', from = '+18017520416')
    @client.account.messages.create(
      from: from,
      to: to,
      body: body,
      media_url: media_url
    )
  end
end

