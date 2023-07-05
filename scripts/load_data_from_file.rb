file = File.open(ARGV.first, 'r')

# Hash to store campaigns and their ID
campaigns = Hash.new

votes = file.readlines
for vote in votes
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
    unless campaigns.key?(campaign)
      new_campaign = Campaign.new(name: campaign)
      new_campaign.save

      campaigns[campaign] = new_campaign.id
    # Create new vote record
    else
      new_vote = Vote.new(epoch: epoch, campaign_id: campaigns[campaign], validity: validity, choice: choice)
      new_vote.save
    end
  end
end