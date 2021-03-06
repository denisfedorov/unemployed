require 'spec_helper'

describe "Authentication" do

  before (:all) do
    @fb_user = create_fb_user
    caps = Selenium::WebDriver::Remote::Capabilities.phantomjs(:javascript_enabled => true)
    @driver = Selenium::WebDriver.for :remote, :url => "http://localhost:4444/wd/hub", :desired_capabilities => caps
    @driver.manage.timeouts.implicit_wait = 10 # seconds
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
      # let(:user) { FactoryGirl.create(:user) }
      # before do
      #   fill_in "Email",    with: user.email
      #   fill_in "Password", with: user.password
      #   click_button "Sign in"
      # end
      
      it "should open new window" do
        @driver.get signin_url(:host => "unemployed.local")
        sleep 5
        windows_count = @driver.window_handles.count
        current_window = @driver.window_handle
        @driver.find_element(:id, "sign_in").click
        @driver.window_handles.count.should be > windows_count      
        @driver.switch_to.window @driver.window_handles[windows_count]
      end
      
      it "should open facebook login form" do
        email=@driver.find_element(:name, "email")
        passwd=@driver.find_element(:name, "pass") 
        btn_login=@driver.find_element(:name, "login")
        sleep 10  # otherwise the page is closed before it is completely 
                  # loaded which causes an exception in ghostdriver
        email.send_keys(@fb_user["email"])
        passwd.send_keys(@fb_user["password"])
        btn_login.click
      end

      ## commented out because FB currently doesn't take default permissions specified in the app settings
      ##
      # it "should open Facebook application authorisation form" do
      #   confirm=@driver.find_element(:name, "__CONFIRM__")
      #   confirm.click
      #   @driver.window_handles.count.should == windows_count
      #   @driver.switch_to.window current_window
      # end

      it "should open user home page" do
        @driver.save_screenshot("homepage.png")
        @driver.find_element(:class, "user_name").should_not be_nil
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

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end

          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the default (profile) page" do
              page.should have_selector('title', text: user.name) 
            end
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_url) }
        end

        describe "visiting user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in') }
        end
      end

    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should have_selector('title', text: full_title('')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_url) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_url) }        
      end
    end
  end
end