require 'sinatra'
require 'json'
require 'bundler/setup'
require 'alexa_rubykit'
require 'httparty'
require 'open-uri'
require 'ffaker'
require 'twilio-ruby'
require './philosophy'
require './insult'
require './shower'
require './messenger'

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
    case request.name
    when "MeanAlexaIntent"
      persons_name = request.slots["PersonName"]["value"]
      insult = Insult.insult
      response.add_speech("#{persons_name}, #{insult}")
      response.add_hash_card( { title: persons_name, subtitle: insult } )
    when "NiceAlexaIntent"
      persons_name = request.slots["PersonName"]["value"]
      motivation = Insult.motivation
      response.add_speech("#{persons_name}, #{motivation}")
      response.add_hash_card( { title: persons_name, subtitle: motivation } )
    when "MessageMeIntent"
      message = request.slots["Message"]["value"]
      Messenger.new.message(message)
      response.add_speech("I sent you, the message: #{message}")
      response.add_hash_card( { title: "Sent you a text message!", subtitle: "I sent you, the message: #{message}" } )
    when "PhilsosophyIntent"
      response.add_speech("#{Philosophy.get_quote.sample}")
    when "ShowerThoughtIntent"
      shower_thought = ShowerThought.get_thought
      response.add_speech(shower_thought)
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
