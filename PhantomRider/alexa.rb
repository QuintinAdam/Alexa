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
      insult = Insult.insult
      response.add_speech("#{persons_name}, #{insult}")
      response.add_hash_card( { title: persons_name, subtitle: insult } )
    elsif request.name == "NiceAlexaIntent"
      persons_name = request.slots["PersonName"]["value"]
      motivation = Insult.motivation
      response.add_speech("#{persons_name}, #{motivation}")
      response.add_hash_card( { title: persons_name, subtitle: motivation } )
    elsif request.name == "PhilsosophyIntent"
      response.add_speech("#{Philosophy.get_quote.sample}")
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
