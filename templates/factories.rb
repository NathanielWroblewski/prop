FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end

  sequence :password do |n|
    "1234567#{n}"
  end

  factory :user do
    email
    password
  end
end
