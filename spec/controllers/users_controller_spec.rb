require 'spec_helper'
require 'factory_girl_rails'
describe UsersController do
  render_views
  describe "GET 'new'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    #User.stub!(:find, @user.id).and_return(@user)
  end
  it "should be successful" do
    get :show, :id =>@user
    response.should be_success
  end
  it "should find the right user" do
    get :show, :id=>@user
    assigns(:user).should == @user
  end
  it "returns http success" do
    get 'new'
    response.should be_success
  end


  it "should have a signup page at '/signup'" do
    get 'new'
    response.should have_selector('title', :content => "Sign up")
  end

  it "should have the right title" do
    get :show, :id=>@user
    response.should have_selector("title", :content => @user.name)
  end

  it "should include the user's name" do
    get :show, :id =>@user
    response.should have_selector("h1", :content=>@user.name)
  end

  it "should have a profile image" do
    get :show, :id =>@user
    response.should have_selector("h1>img", :class=> "gravatar")
  end
end

end
