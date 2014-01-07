# Factory definition
FactoryGirl.define do 
    factory :user do |user|
    user.name "Micael A"
    user.email "email@email.com"
    user.password "pass1"
    user.password_confirmation "pass1"
    end
end
