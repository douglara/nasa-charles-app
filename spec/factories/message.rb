FactoryBot.define do
  factory :message do
    text { Faker::Quote.yoda }
    from_me { false }
    user_id { Faker::IDNumber.valid }
    message_id { Faker::IDNumber.valid }
  end
end