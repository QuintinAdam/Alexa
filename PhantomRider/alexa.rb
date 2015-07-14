require 'sinatra'
require 'json'
require 'bundler/setup'
require 'alexa_rubykit'
require './philosophy'
require './insult'
require 'httparty'
require 'ffaker'

# We must return application/json as our content type.
before do
  content_type('application/json')
end

#enable :sessions
post '/' do
  # Check that it's a valid Alexa request
  request_json = JSON.parse(request.body.read.to_s)
  # Creates a new Request object with the request parameter.
  request = AlexaRubykit.build_request(request_json)

  # We can capture Session details inside of request.
  # See session object for more information.
  session = request.session
  p session.new?
  p session.has_attributes?
  p session.session_id
  p session.user_defined?

  # We need a response object to respond to the Alexa.
  response = AlexaRubykit::Response.new

  # We can manipulate the request object.
  #
  #p "#{request.to_s}"
  #p "#{request.request_id}"

  # Response
  # If it's a launch request
  if (request.type == 'LAUNCH_REQUEST')
    # Process your Launch Request
    # Call your methods for your application here that process your Launch Request.
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
      response.add_speach("#{Philosophy.new.get_quote.sample}")
    else #help intent?
      response.add_speach("I do not want to help you!")
    end
  end

  if (request.type =='SESSION_ENDED_REQUEST')
    # Wrap up whatever we need to do.
    p "#{request.type}"
    p "#{request.reason}"
    halt 200
  end

  # Return response
  response.build_response
end
