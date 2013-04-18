module UsersHelper

  def user_pic(user)
  	if user.provider == "facebook"
  		pic_url = user.pic_url
  		if !pic_url.empty?
  		  image_tag(user.pic_url, alt: user.name, class: "gravatar")
  		end
  	end
  end
end
