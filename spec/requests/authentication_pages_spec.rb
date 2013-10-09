# encoding: UTF-8
require 'spec_helper'

def capy_trace(text)
  STDOUT.puts "capy_trace #{text}"
  STDOUT.puts "Session: " + Capybara.current_session.to_s
  STDOUT.puts "Url: " + page.current_url
end

describe "Authentication" do
  before (:all) do 
    OmniAuth.config.test_mode = true
    @fb_user = load_fb_user
  end
  after (:all) { OmniAuth.config.test_mode = false }
  
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_title('Sign in') }
  end

  describe "signin" do
  
    describe "with invalid information" do
      before do 
        visit signin_path
        click_button "Sign in"
      end

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
    
    describe "with valid facebook account" do
      before { @user = sign_in_fb_user(@fb_user) }

      it "should signin with facebook" do
        @user.should_not be_nil
        should have_title(@user.name)
      end

      it "should have proper links" do 
        should have_button('Рекомендовать')
        should have_link('Profile', href: user_path(@user))
        should have_link('Settings', href: edit_user_path(@user))
        should have_link('Sign out', href: signout_path)
        should_not have_link('Sign in', href: signin_path)
      end

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { load_user(0) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          sign_in_user(user)
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_title('Edit user')
          end

          describe "when signing in again" do
            before do
              delete signout_path
              sign_in_user(user)
            end

            it "should render the default (profile) page" do
              page.should have_title(user.name) 
            end
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_url) }
        end

        describe "visiting user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end
      end

    end

    # describe "as wrong user" do
    #   let(:user) { FactoryGirl.create(:user) }
    #   let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
    #   before { sign_in user }

    #   describe "visiting Users#edit page" do
    #     before { visit edit_user_path(wrong_user) }
    #     it { should have_selector('title', text: full_title('')) }
    #   end

    #   describe "submitting a PUT request to the Users#update action" do
    #     before { put user_path(wrong_user) }
    #     specify { response.should redirect_to(root_url) }
    #   end
    # end

    # describe "as non-admin user" do
    #   let(:user) { FactoryGirl.create(:user) }
    #   let(:non_admin) { FactoryGirl.create(:user) }

    #   before { sign_in non_admin }

    #   describe "submitting a DELETE request to the Users#destroy action" do
    #     before { delete user_path(user) }
    #     specify { response.should redirect_to(root_url) }        
    #   end
    # end
  end
end