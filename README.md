# DRUG Alexa

Look at code to find methods here - Alexa ruby gem: https://github.com/damianFC/alexa-rubykit

## Sample Calls

Calls always start with "Alexa {Ask|Tell|Talk to|Open|Launch|Start|Use|Resume|Run|Load|Begin} AppName {what|how|to|about|for|if|whether|or whatever else you want}"

Alexa ask MeanAlexa to insult Cody

or

Alexa run MeanAlexa insult Cody

DrugAddict:
  -
DrugDealer:
  -
DrugMule:
  -
DrugUser:
  -
GorillaMan:
  -
MoltenMan:
  -
PhantonRider:
  -
ShrunkenBones:
  -

## Setting up Alexa Ruby

### Base Setup

1. Clone sample app: `https://github.com/damianFC/alexa-rubykit`
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
  - ```
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
