class Subscription < ApplicationRecord
  validates :user_phone, :region, presence: true, allow_blank: false
end
