require 'spec_helper'

describe "Authentication" do

  before (:all) do
    @fb_user = create_fb_user
  end

  after (:all) do
    delete_fb_user(@fb_user)
  end

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end

  @javascript
  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
    
    describe "with valid facebook account" do
      
      before do 
        visit signin_url(:host => "unemployed.local")
        save_screenshot "signin.png"
      end
      # print Capybara.current_session.current_path
      # print Capybara.current_driver
      # Capybara.default_wait_time = 10
      # visit signin_path #(:host => "unemployed.local")

      #save_screenshot 'signin.png'
      it { should have_link("Sign in with Facebook") }

      describe "open facebook login", :js => true do 
        before { click_link("Sign in with Facebook") }
        it "should open the dialog" do
          save_screenshot "aftersignin.png"
          within_window 'Facebook - PhantomJS' do
            it { should have_field(:name, 'email') }
            it { should have_field(:name, 'pass') }
            it { should have_button(:name, 'login') }

            fill_in 'email', :with => @fb_user["email"]
            fill_in 'pass', :with => @fb_user["password"]
            click_button :name => 'login'
          end
          it { should have_selector(:class, 'user_name') }
        end
      end



      # it { should have_selector('title', text: user.name) }

      # it { should have_link('Users',    href: users_path) }
      # it { should have_link('Profile', href: user_path(user)) }
      # it { should have_link('Settings', href: edit_user_path(user)) }
      # it { should have_link('Sign out', href: signout_path) }
      # it { should_not have_link('Sign in', href: signin_path) }

      # describe "followed by signout" do
      #   before { click_link "Sign out" }
      #   it { should have_link('Sign in') }
      # end
    end
  end

  
end