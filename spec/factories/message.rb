FactoryBot.define do
  factory :message do
    text { Faker::Quote.yoda }
    from_me { false }
    user_id { Faker::IDNumber.valid }
    message_id { Faker::IDNumber.valid }
    factory :message_valid_cep do
      text { '81900500' }
    end
    factory :message_invalid_cep do
      text { '' }
    end
  end
end