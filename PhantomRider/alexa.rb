require 'sinatra'
require 'json'
require 'bundler/setup'
require 'alexa_rubykit'
require './philosophy'
require './insult'
require 'httparty'
require 'ffaker'

before do
  content_type('application/json')
end

post '/' do
  request_json = JSON.parse(request.body.read.to_s)
  request = AlexaRubykit.build_request(request_json)

  session = request.session

  response = AlexaRubykit::Response.new

  if (request.type == 'LAUNCH_REQUEST')
    response.add_speech('Phantom Rider is running!')
    response.add_hash_card( { title: 'Phantom Rider Run', subtitle: 'Phantom Rider Running!' } )
  end

  if (request.type == 'INTENT_REQUEST')
    if request.name == "MeanAlexaIntent"
      persons_name = request.slots["PersonName"]["value"]
      message = HTTParty.get("http://pleaseinsult.me/api?severity=random")
      response.add_speech("#{persons_name}, #{message['insult']}")
      response.add_hash_card( { title: persons_name, subtitle: message['insult'] } )
    elsif request.name == "NiceAlexaIntent"
      persons_name = request.slots["PersonName"]["value"]
      message = HTTParty.get("http://pleasemotivate.me/api")
      response.add_speech("#{persons_name}, #{message['motivation']}")
      response.add_hash_card( { title: persons_name, subtitle: message['motivation'] } )
    elsif request.name == "PhilsosophyIntent"
      response.add_speech("#{Philosophy.new.get_quote.sample}")
    else
      response.add_speech("I do not want to help you!")
    end
  end

  if (request.type =='SESSION_ENDED_REQUEST')
    p "#{request.type}"
    p "#{request.reason}"
    halt 200
  end

  response.build_response
end
