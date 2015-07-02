require 'sinatra'
require 'json'
require 'bundler/setup'
require 'alexa_rubykit'
require 'messenger'

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
    response.add_speech('Drug Addict is running!')
    response.add_hash_card( { title: 'Drug Addict Run', subtitle: 'Drug Addict Running!' } )
  end

  if (request.type == 'INTENT_REQUEST')
    # Process your Intent Request
    p "#{request.slots}"
    p "#{request.name}"

    case request.name
    when "SendMessageIntent"
      persons_name = request.slots["PersonName"]["value"]
      message = request.slots["Message"]["value"]

      people = {'ben' => '+18019461510', 'lily' => '+18018100225', 'lilly' => '+18018100225' }

      phone_number = people[persons_name]

      Messenger.new().message(message, phone_number)
      # get insult
      response.add_speech("I sent #{persons_name}, the message: #{message}")
      response.add_hash_card( { title: "Sent a text message to #{persons_name} !", subtitle: "I sent #{persons_name}, the message: #{message}" } )
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
