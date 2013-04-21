include ApplicationHelper

def create_fb_user
  test_users.create(false)
end

def delete_fb_user(fb_user)
  test_users.delete(fb_user)
end

def test_users
	@test_users ||= Koala::Facebook::TestUsers.new(
  	                 :app_id => ENV['FACEBOOK_APP_ID'],
  	                 :secret => ENV['FACEBOOK_SECRET'])
end

def sign_in_fb_user(driver, fb_user)
#	driver.get signin_url
#	driver.find_element(:id, "sign_in").click
end	
