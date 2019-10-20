class Conversation < ApplicationRecord
  belongs_to :user
  has_many :messages
  enum status: {'inactive': 0, 'active': 1}

  scope :actives, -> {
    where(status: 'active')
  }
  scope :inactive, -> {
    where(status: 'inactive')
  }
end
