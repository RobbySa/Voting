# frozen_string_literal: true

class CampaignsController < ApplicationController
  def index
    @campaigns = view_all_campaigns
  end

  def show
    @campaigns = view_all_campaigns
    @campaign = view_campaign(params[:id])

    @vote_split = get_campaign_details(@campaign)
  end

  private

  def view_all_campaigns
    Campaign.all
  end

  def view_campaign(campaign_id)
    Campaign.find(campaign_id)
  end

  def get_campaign_details(campaign)
    vote_split = Hash.new

    for vote in campaign.votes
      if vote.validity == 'during'
        vote_split[vote.choice] = (vote_split[vote.choice] || 0) + 1
      else
        vote_split['Invalid'] = (vote_split['Invalid'] || 0) + 1
      end
    end

    vote_split
  end
end