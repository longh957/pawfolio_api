FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "password"
    name { Faker::GameOfThrones.dragon }
  end
end
