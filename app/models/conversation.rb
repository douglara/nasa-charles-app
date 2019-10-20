class Conversation < ApplicationRecord
  belongs_to :user
  has_many :messages
  enum status: {'inactive': 0}
end
