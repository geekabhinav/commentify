class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  has_many :activities, :dependent => :destroy

  validates_uniqueness_of :email

  state_machine :status, :initial => :unconfirmed do
    event :authenticate do
      transition [:unconfirmed] => :authenticated
    end

    event :activate do
      transition [:authenticated] => :active
    end

    event :stop do
      transition [:active] => :authenticated
    end
  end

  CONSUMER_KEY = 'khgfNB2ydQvIPTC8PQWE95GD0JC7VTewt2vIqnPD'
  CONSUMER_SECRET = 'lsC37t1S8jiKCyhk6EgxOZOLIpAp6ijCha1VFFq8'

  BASE_URL = 'https://api.500px.com'

  def get_token
    consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, {
        :site               => BASE_URL,
        :request_token_path => '/v1/oauth/request_token',
        :access_token_path  => '/v1/oauth/access_token',
        :authorize_path     => '/v1/oauth/authorize'
    })

    request_token = consumer.get_request_token()
    access_token = consumer.get_access_token(request_token, {}, { :x_auth_mode => 'client_auth', :x_auth_username => self.username, :x_auth_password => self.password_500px })

    self.access_secret = access_token.secret
    self.access_token = access_token.token
    self.save!
    self.authenticate!
  end


  def authenticate_500px
    consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, { :site => BASE_URL })
    OAuth::AccessToken.new(consumer, self.access_token, self.access_secret)
  end

  def get_links
    unless self.active?
      puts 'User not active. Quit!'
      return false
    end

    access_token = authenticate_500px
    url = '/v1/photos?feature=fresh_today&rpp=50&sort=created_at&sort_direction=desc&include_states=voted&tags=1'
    request = access_token.get(url).body
    response = JSON.parse(request)

    response['photos'].each do |photo|
      next if photo['liked']

      comment = Comment.first(:order => "RANDOM()")
      self.delay.execute_bot({:body => comment.body, :photo_id => photo['id'].to_i})
    end
  end

  # Pass a hash of options like
  # args = {
  # 	:photo_id => 22222222,
  # 	:body => 'This is a comment'
  # }
  def execute_bot(args = {})
    unless self.active?
      puts 'User not active. Quit!'
      return false
    end

    if args[:photo_id].blank?
      puts 'Photo ID not provided. Quit!'
      return false
    end

    if args[:body].blank?
      puts 'Comment body not provided. Quit!'
      return false
    end

    photo_exists = Activity.where(:photo_id => args[:photo_id].to_i, :user_id => self.id).first

    if photo_exists
      puts 'Photo has already been liked and commented on. Quit!'
      return false
    end

    access_token = authenticate_500px

    #  LIKE PHOTO ================
    url = "/v1/photos/#{args[:photo_id].to_s}/vote"
    params = {
        :vote => 1
    }

    request = access_token.post(url, params).body
    request = JSON.parse(request)

    # if request[:status].to_i == 200
      Activity.add('like', args[:photo_id], self.id )
    # end

    sleep(5)

    # COMMENT ON PHOTO ===================
    url = "/v1/photos/#{args[:photo_id].to_s}/comments"
    params = {
        :body => args[:body]
    }
    request = access_token.post(url, params).body
    request = JSON.parse(request)
    # if request[:status].to_i == 200
      Activity.add('comment', args[:photo_id], self.id )
    # end

    sleep(rand(30-60))
  end
end