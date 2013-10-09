include ApplicationHelper

def create_fb_user(name)
  user = test_users.create(true, "email,publish_actions")
  test_users.update(user, {:name => name})
  user = user.merge({ "name" => name })
end

def load_fb_user(number = 0)
  @loaded_users ||= YAML.load_stream(File.read(Rails.root.join('spec/test_data/test_users.yaml')))
  return @loaded_users[number]["user#{number}"]
end

def delete_fb_user(fb_user)
  test_users.delete(fb_user)
end

def test_users
	@test_users ||= Koala::Facebook::TestUsers.new(
  	                 :app_id => ENV['FACEBOOK_APP_ID'],
  	                 :secret => ENV['FACEBOOK_SECRET'])
end

def create_fb_auth_hash(user)
  auth_hash= {
      :provider => 'facebook',
      :uid => user["id"],
      :info => {
        :email => user["email"],
        :name => user["name"]
      },
      :credentials => {
        :token => user["access_token"],
        :expires_at => (Time.now + 2.hours).to_i,
        :expires => true
      }
    }
end

def create_fb_auth_hash_from_db(user)
  auth_hash= {
      :provider => 'facebook',
      :uid => user.uid,
      :info => {
        :email => user.email,
        :name => user.name
      },
      :credentials => {
        :token => user.oauth_token,
        :expires_at => (Time.now + 2.hours).to_i,
        :expires => true
      }
    }
end

def create_user(user)
  User.where(:provider => 'facebook', :uid => user["id"]).first_or_initialize do |new_user|
    new_user.email = user["email"]
    new_user.name = user["name"]
    new_user.generate_password
    new_user.oauth_token = user["access_token"]
    new_user.oauth_expires_at = Time.now + 2.hours
    new_user.save!
  end
end

def sign_in_fb_user(user)
	OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(create_fb_auth_hash(user))
  driver = Capybara.current_session.driver        # it works only with RackTest driver
  driver.header("omniauth.auth", OmniAuth.config.mock_auth[:facebook])
  visit signin_path
  visit 'auth/facebook/callback'
  user = User.where(OmniAuth.config.mock_auth[:facebook].slice(:provider, :uid)).first
end

def load_user(number = 0)
  user = create_user(load_fb_user(number))
end

def sign_in_user(user)
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(create_fb_auth_hash_from_db(user))
  driver = Capybara.current_session.driver        # it works only with RackTest driver
  driver.header("omniauth.auth", OmniAuth.config.mock_auth[:facebook])
  visit signin_path
  visit 'auth/facebook/callback'
end