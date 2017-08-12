FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    name { Faker::GameOfThrones.dragon }

    factory :user_with_pets do
      after(:create) do |user, _evaluator|
        create_list(:pet, 4, user: user)
      end
    end
  end
end
