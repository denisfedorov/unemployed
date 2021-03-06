# encoding: UTF-8

FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :service do
    sequence(:name)  { |n| "Человек #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    phone  { ('0'..'9').to_a.shuffle[0..9].join }
    title "Женская стрижка" 
    description "Стрижка, окраска и все такое..."
  end
end