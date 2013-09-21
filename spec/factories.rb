FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@email.com"
  end
end
