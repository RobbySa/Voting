# Functions to make code more readable
def get_votes_from_file(file_name)
  file = File.open(file_name, 'r')
  file.readlines
end

def campaign_exists(name, campaign_cache)
  get_campaign_by_name(name, campaign_cache).present?
end

def get_campaign_by_name(name, campaign_cache)
  campaign = campaign_cache.detect { |c| c.name == name }

  return campaign if campaign.present?

  campaign = Campaign.find_by(name: name)

  campaign_cache.append(campaign) if campaign.present?

  campaign
end

campaign_cache = []

# Main script
all_votes = get_votes_from_file(ARGV.first)

ActiveRecord::Base.transaction do
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
      unless campaign_exists(campaign, campaign_cache)
        new_campaign = Campaign.create(name: campaign)
      end

      # Create new vote record
      new_vote = Vote.create(epoch: epoch, campaign: get_campaign_by_name(campaign, campaign_cache), validity: validity, choice: choice)
    end
  end
end
