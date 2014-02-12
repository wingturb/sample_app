# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
    before(:each) do
        @attr = { :name => "example user", :email => "user@user.com", :password => "foobar", :password_confirmation => "foobar"}
   end
    
    it "should create a new instance given valid attributes" do
        User.create!(@attr)
    end

    it "should require a name" do
        no_name_user = User.new(@attr.merge(:name => ""))
        no_name_user.should_not be_valid
    end
    
    it "should reject name identical" do
        User.create!(@attr)
        dupUser = User.new(@attr)
        dupUser.should_not be_valid
    end
    describe "password confirmation" do
        it "should not have empty password" do 
            User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
        end
        it "password validations" do
            User.new(@attr.merge(:password_confirmation=> "invalid")).should_not be_valid
        end
    end
    describe "password encryption" do
        before(:each) do
            @user =User.create!(@attr)
        end

        it "should have an encrypted password attribute" do
            @user.should respond_to(:encrypted_password)
        end
        it "should be true if password matches" do
            @user.has_password?(@attr[:password]).should be_true
        end
        it "should be false if password not match" do
            @user.has_password?('wrong password').should be_false
        end
        it "should return user if email/password matches" do
            matching_user = User.authenticate(@attr[:email], @attr[:password])
            matching_user.should == @user
        end
        it "should return nil if email/password mismatches" do
            matching_user = User.authenticate("not_exist", @attr[:password])
            matching_user.should be_nil 
        end
    end

    describe "admin attribute" do
        before(:each) do
            @user = User.create(!@attr)
        end
    
        it "should respond to admin" do
            @user.should respond_to(:admin)
        end

        it "should be convertible to an admin" do
            @user.toggle!(:admin)
            @user.should be_admin
        end
    end
    describe "micropost associations" do
        before (:each) do
            @user = FactoryGirl.create(:user)
            @mp1 = FactoryGirl.create(:micropost, :user=>@user, :created_at=>1.day.ago)
            @mp2 = FactoryGirl.create(:micropost, :user=>@user, :created_at=>1.hour.ago)

        end

        it "should have a microposts attribute" do
            @user.should respond_to(:microposts)
        end

        it "should have the right microposts in the right order" do
            @user.microposts.should == [@mp2, @mp1]
        end

        it "should destroy associated microposts" do
            @user.destroy
            [@mp1, @mp2].each do |micropost|
                Micropost.find_by_id(micropost.id).should be_nil
            end
        end

        describe "status feed" do
            it "should have a feed" do
                @user.should respond_to (:feed)
            end

            it "should include the user's microposts" do
                @user.feed.include?(@mp1).should be_true
                @user.feed.include?(@mp2).should be_true
            end

            it "should not include a different user's micropost" do
                mp3 = FactoryGirl.create(:micropost, :created_at=>2.day.ago)
                @user.feed.include?(mp3).should be_false
            end
        end
    end

    describe "relationships" do
        before(:each) do
            @user = User.create!(@attr)
            @followed = FactoryGirl.create(:user)
        end

        it "should have a relationships method" do
            @user.should respond_to(:relationships)
        end

        it "should have a following method" do
            @user.should respond_to(:following)
        end

        it "should have a following? method" do
            @user.should respond_to(:following?)
        end

        it "should have a follow! method" do
            @user.should respond_to(:follow!)
        end

        it "should follow another user" do
            @user.follow!(@followed)
            @user.should be_following(@followed)
        end

        it "should include the followed user in the following arrary" do
            @user.follow!(@followed)
            @user.following.should include(@followed)
        end

        it "should have an unfollow! method" do
            @followed.should respond_to(:unfollow!)
        end

        it "should unfollow a user" do
            @user.follow!(@followed)
            @user.unfollow!(@followed)
            @user.should_not be_following(@followed)
        end

        it "should have a reversed_relationships method" do
            @user.should respond_to(:reversed_relationships)
        end

        it "should have a followers method" do
            @user.should respond_to(:followers)
        end

        it "should include the follower in the followers arrary" do
            @user.follow!(@followed)
            @followed.followers.should include(@user)
        end

    end
end
