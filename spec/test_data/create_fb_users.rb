require Rails.root.join('spec/support/fb_utils.rb')
@user_count = 0

def create_user_yaml(name)
	user = create_fb_user(name)
#	a_hash = create_fb_auth_hash(user)
#	a_hash[:credentials][:expires_at] = Time.new('2050-01-01').to_i
	fb_user = { "user#{@user_count}" => user }
	@user_count += 1
	return fb_user.to_yaml
end

test_users_file = File.new(Rails.root.join('spec/test_data/test_users.yaml'), 'a+')
test_users_file.write(create_user_yaml('John Doe'))
test_users_file.write(create_user_yaml('Michael Jackson'))
test_users_file.write(create_user_yaml('Frank Sinatra'))
test_users_file.write(create_user_yaml('John Lennon'))
test_users_file.write(create_user_yaml('Jim Morrison'))
test_users_file.write(create_user_yaml('Scarlet Johanson'))
test_users_file.write(create_user_yaml('Annie Lenox'))
