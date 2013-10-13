class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation

  has_many :recommendations, :dependend => :destroy
  has_many :recommended_services, through: :recommendations, source: :service
  
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.email = auth.info.email
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.generate_password
      user.save!
    end
  end

  def generate_password
     self.password = (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a).shuffle[0..7].join
     self.password_confirmation = password
  end

  def pic_url
    me = graph.get_object("me")
    graph.get_picture(me["username"])

  rescue 
    ''
  end

  def friend_list
  end

  private

    def graph
      @graph ||= Koala::Facebook::API.new(oauth_token)
    end

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
