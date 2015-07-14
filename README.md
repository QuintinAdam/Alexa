# DRUG Alexa

Project for the downtown ruby user group meetup

Look at code to find methods here - Alexa ruby gem: https://github.com/QuintinAdam/alexa-rubykit

## Sample Calls

Calls always start with "Alexa {Ask|Tell|Talk to|Open|Launch|Start|Use|Resume|Run|Load|Begin} AppName {what|how|to|about|for|if|whether|or whatever else you want}" followed by the rest of your command.

Alexa ask MeanAlexa to insult Cody

or

Alexa run MeanAlexa insult Cody

#### Team DrugAddict:

  Example Calls:
    -

#### Team DrugDealer:

  Example Calls:
    -

#### Team DrugMule:

  Example Calls:
    -

#### Team DrugUser:

  Example Calls:
    -

#### Team GorillaMan:

  Example Calls:
    -

#### Team MoltenMan:

  Example Calls:
    -

#### Team PhantonRider:

  Example Calls:
    - insult and motivate
    - Alexa ask Phantom Rider to insult {Quintin|PersonName}
    - Alexa ask Phantom Rider insult {Quintin|PersonName}
    - Alexa ask Phantom Rider to motivate {Quintin|PersonName}
    - Alexa ask Phantom Rider motivate {Quintin|PersonName}
    - prophesize
    - Alexa ask Phantom Rider to prophesize
    - Alexa ask Phantom Rider prophesize
    - Alexa ask Phantom Rider be wise
    - Alexa ask Phantom Rider to be wise
    - shower thoughts
    - Alexa ask Phantom Rider to tell me a shower thought
    - Alexa ask Phantom Rider tell me a shower thought
    - Alexa ask Phantom Rider give me a shower thought
    - Alexa ask Phantom Rider whats on your mind
    - Alexa ask Phantom Rider to tell me whats on your mind
    - text message
    - Alexa ask Phantom Rider to text this message {message|Message}
    - Alexa ask Phantom Rider text this message {message|Message}
    - Alexa ask Phantom Rider text this {message|Message}
    - Alexa ask Phantom Rider text me {message|Message}
    - Alexa ask Phantom Rider to text me {message|Message}
    - Alexa ask Phantom Rider to text me the message {message|Message}
    - Alexa ask Phantom Rider text me the message {message|Message}
    - Alexa ask Phantom Rider message this {message|Message}
    - Alexa ask Phantom Rider to message this {message|Message}
    - Alexa ask Phantom Rider message me {message|Message}
    - Alexa ask Phantom Rider to message me {message|Message}
    - help
    - Alexa ask Phantom Rider for help
    - Alexa ask Phantom Rider to help
    - Alexa ask Phantom Rider help
    - Alexa ask Phantom Rider for help me
    - Alexa ask Phantom Rider to help me
    - Alexa ask Phantom Rider help me
    - Alexa ask Phantom Rider wat

#### Team ShrunkenBones:

  Example Calls:
    -


## Contributing

After you or your team have picked which server you want fork this project and work on your own branch. When you want to test out the results make a pull request to the project and I will merge and deploy the code.

You need to define the intents in the IntentSchema and the phrases you want supported in the SampleUtterances file.

### Request Body Syntax

```
{
  "version": "string",
  "session": {
    "new": boolean,
    "sessionId": "string",
    "application": {
      "applicationId": "string"
    },
    "attributes": {
      "string": object
    },
    "user": {
      "userId": "string"
    }
  },
  "request": object
}
```

### Sample Intent Request

```
{
  "type": "IntentRequest",
  "requestId": "string",
  "timestamp": "string",
  "intent": {
    "name": "string",
    "slots": {
      "string": {
        "name": "string",
        "value": "string"
      }
    }
  }
}
```

## Setting up your own Alexa Ruby server (if you have your own Echo)

### Base Setup

1. Clone sample app: `https://github.com/QuintinAdam/alexa-rubykit`
2. Install eb (elastic beanstock command line tool)
  - Guide:
    - http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html
  - Command for osx:
    - `curl -s https://s3.amazonaws.com/elasticbeanstalk-cli-resources/install-ebcli.py | python`
    - `eb --version`
3. Run `eb init`
  - Chose: us-east-1 : US East (N. Virginia)
  - Adds your AWS credentials
  - Make a application name
4. Run `eb create` this will create your environment
  - use defaults
5. Verify it is up and running by logging into aws console
  - https://console.aws.amazon.com/elasticbeanstalk
6. Alexa only uses https so next we need to generate ssl certs

### Generating SSL Certs

1. In your app `mkdir temp-cert`
2. `cd temp-cert`
3. Generate key `openssl genrsa 2048 > privatekey.pem`
4. Generate a certificate request `openssl req -new -key privatekey.pem -out csr.pem`

  ```
    Country Name (2 letter code) [AU]:US
    State or Province Name (full name) [Some-State]:Utah
    Locality Name (eg, city) []:Salt Lake City
    Organization Name (eg, company) [Internet Widgits Pty Ltd]:Hobby
    Organizational Unit Name (eg, section) []:Demo
    Common Name (e.g. server FQDN or YOUR name) []:test-alexa-ruby-dev.elasticbeanstalk.com
    Email Address []:quintinjadam@gmail.com

    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:
    An optional company name []:
  ```

5. Generate self signed certificate `openssl x509 -req -days 365 -in csr.pem -signkey privatekey.pem -out server.crt`
6. Upload cert to amazon `aws iam upload-server-certificate --server-certificate-name test-rubykit --certificate-body file://server.crt --private-key file://privatekey.pem`
  - install aws command line interface `pip install awscli`

### Beanstock Setup

1. Back on your elastic beanstock you want to go under configurations and load balancer
  - protocol must be https
  - Secure listener port is 443
  - select your uploaded cert (test-rubykit)

### Alexa App Setup

1. Create a new echo application
  - Endpoint: https://test-alexa-ruby-dev.elasticbeanstalk.com (beanstock address)
2. Add Intent Schema & Sample Utterances
3. Upload self signed cert `cat server.crt`

### Pushing Changes

1. Commit Changes
2. `eb deploy`

### Other Notes

When deploying to eb with gems coming from git include the .ebextensions folder


```
openssl genrsa 2048 > privatekey.pem
openssl req -new -key privatekey.pem -out csr.pem
openssl x509 -req -days 365 -in csr.pem -signkey privatekey.pem -out server.crt

aws iam upload-server-certificate --server-certificate-name APPNAME --certificate-body file://server.crt --private-key file://privatekey.pem
cat server.crt
```

https://console.aws.amazon.com/elasticbeanstalk
https://developer.amazon.com/edw/home.html#/
https://console.aws.amazon.com/lambda/home?region=us-east-1#/functions
