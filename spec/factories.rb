# Factory definition
FactoryGirl.define do 
	factory :user do |user|
		sequence :name do |n|
			"sequese_person-#{n}"
		end
		sequence :email do |n|
			"sequese_person-#{n}@factory.com"
		end
		user.password "pass1"
		user.password_confirmation "pass1"
	end
    # factory :user do |user|
    # user.name "Micael A"
    # user.email "email@email.com"
    # user.password "pass1"
    # user.password_confirmation "pass1"
    # end

    factory :micropost do |micropost|
    	sequence :content do |n|
    		"this is content--#{n}"
    	end
    	micropost.association :user
    end

    sequence :email do |n|
    	"sequese_person-#{n}@factory.com"
    end
    sequence :name do |n|
    	"sequese_person-#{n}"
    end
end

