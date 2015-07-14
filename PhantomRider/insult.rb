class Insult

  def self.insult
    message = HTTParty.get("http://pleaseinsult.me/api?severity=random")
    message['insult']
  end

  def self.motivate
    message = HTTParty.get("http://pleasemotivate.me/api")
    message['motivation']
  end

end
