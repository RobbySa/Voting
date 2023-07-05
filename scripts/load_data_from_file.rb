# Functions to make code more readable
def get_votes_from_file(file_name)
  file = File.open(file_name, 'r')
  file.readlines
end

def campaign_exists(name)
  get_campaign_by_name(name).present?
end

def get_campaign_by_name(name)
  Campaign.find_by(name: name)
end

# Main script
all_votes = get_votes_from_file(ARGV.first)
for vote in all_votes
  # regular expression which captures all the information that we need to store from each vote
  regex = /VOTE (\d+) Campaign:(\w+) Validity:(\w+) Choice:(\w+) CONN:\w+ MSISDN:\d+ GUID:[A-F0-9-]+ Shortcode:\d+/
  matcher = vote.match(regex)

  # Any vote that doesn't match the regular expression is not well-formed and is therefore discarted
  if matcher
    epoch    = matcher[1]
    campaign = matcher[2]
    validity = matcher[3]
    choice   = matcher[4]

    # Generate campaign record if not already present in DB
    unless campaign_exists(campaign)
      new_campaign = Campaign.new(name: campaign)
      new_campaign.save
    end

    # Create new vote record
    new_vote = Vote.new(epoch: epoch, campaign: get_campaign_by_name(campaign), validity: validity, choice: choice)
    new_vote.save
  end
end
