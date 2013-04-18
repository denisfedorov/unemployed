include ApplicationHelper

def create_fb_user
  test_users.create(true, "email,publish_actions")
end

def delete_fb_user(user)
  test_users.delete(user)
end

def test_users
	@test_users ||= Koala::Facebook::TestUsers.new(
  	                 :app_id => ENV['FACEBOOK_APP_ID'],
  	                 :secret => ENV['FACEBOOK_SECRET'])
end
