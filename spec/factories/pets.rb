FactoryGirl.define do
  factory :pet do
    name { Faker::WorldOfWarcraft.hero }
    user
    dob { Faker::Date.birthday(1, 18) }
  end
end
