class User < ApplicationRecord
  has_many :conversations
  has_many :messages, through: :conversations
end
