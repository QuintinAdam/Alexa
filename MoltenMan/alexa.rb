require 'sinatra'
require 'json'
require 'bundler/setup'
require 'alexa_rubykit'

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
    response.add_reprompt('Molten Man is running and ready to insult yo face! You can insult by saying, insult cody!')
    response.add_hash_card( { title: 'Molten Man Running', subtitle: 'Molten Man is Runninggg!' } )
  end

  if (request.type == 'INTENT_REQUEST')
    # Process your Intent Request
    p "#{request.slots}"
    # "{\"PersonName\"=>{\"name\"=>\"PersonName\", \"value\"=>\"cody\"}}"
    # request.slots
    p "#{request.name}"
    # "MeanAlexaIntent"
    p "xxxxxxxxxxxxxx"
    p "#{request.add_slots(request.slots)}"
    p "#{request.slots}"
    if request.name == "MeanAlexaIntent"
      persons_name = 'cody'
      # get insult
      response.add_speech("I received an intent named #{request.name}?")
      response.add_hash_card( { title: 'Molten Man Intent', subtitle: "Intent #{request.name}" } )
    elsif request.name == "NiceAlexaIntent"
      # get motivation
    elsif reuqest.name == "TellMeAboutIntent"

    else #help intent?

    end
    response.add_speech("I received an intent named #{request.name}?")
    response.add_hash_card( { title: 'Molten Man Intent', subtitle: "Intent #{request.name}" } )
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
