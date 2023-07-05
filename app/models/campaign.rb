class Campaign < ApplicationRecord
  has_many :votes

  delegate :size, to: :votes, prefix: true, allow_nil: true
end
