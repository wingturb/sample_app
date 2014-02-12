require 'faker'
namespace :db do
	desc "Fill database with sample data"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		make_users
		make_microposts
		make_relationships
	end
	def make_users
		admin = User.create!(:name => "admin",
			:email => "admin@admin.com",
			:password => "admin",
			:password_confirmation => "admin")
		admin.toggle!(:admin)

		20.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "password"
			User.create!(:name => name,
				:email => email,
				:password => password,
				:password_confirmation => password)
		end
	end
	def make_microposts
		User.all(:limit=>6).each do |user|
			50.times do
				user.microposts.create!(:content=>Faker::Lorem.sentence(5))
			end
		end
	end
	def make_relationships
		users = User.all(:limit=>30)
		user = users.first
		following = users[1..10]
		followers = users[3..5]
		following.each{|followed| user.follow!(followed)}
		followers.each{|follower| follower.follow!(user)}
	end

end