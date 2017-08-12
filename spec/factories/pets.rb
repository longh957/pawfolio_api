FactoryGirl.define do
  factory :pet do
    name 'Bubbles'
    user
    dob { Faker::Date.birthday(1, 18) }
  end
end
