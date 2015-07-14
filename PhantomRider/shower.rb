class ShowerThought
  SHOWERTHOUGHTURL = "http://www.reddit.com/r/showerthoughts.json"
  def self.get_thought
    poop_url = open(SHOWERTHOUGHTURL)
    body = File.read(poop_url)
    json = JSON.parse(body)
    post = json["data"]["children"].sample
    post['data']["title"]
  end
end
