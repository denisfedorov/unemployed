module UsersHelper

  def fb_pic(user)
  	image_tag(user.pic_url, alt: user.name, class: "gravatar")
  end
end
