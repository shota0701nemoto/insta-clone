class User < ApplicationRecord
    ## ----------------Facebookログイン機能--------------------
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  def self.find_for_oauth(auth)
           user = User.where(uid: auth.uid, provider: auth.provider).first

           unless user
             user = User.create(
               uid:      auth.uid,
               provider: auth.provider,
               email:    auth.info.email,
               password: Devise.friendly_token[0, 20]
             )
           end
           user
         end
  ## ----------------Facebookログイン機能--------------------

  attr_accessor :remember_token

   validates :name,  presence: true, length: { maximum:  50 }
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   validates :email, presence: true, length: { maximum: 255 },
                     format: { with: VALID_EMAIL_REGEX },
                     uniqueness: { case_sensitive: false }
   has_secure_password
   validates :password, presence: true,
     length: { minimum: 6 }, allow_nil: true

   def User.digest(string)
     cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                   BCrypt::Engine.cost
     BCrypt::Password.create(string, cost: cost)
   end

   def User.new_token
     SecureRandom.urlsafe_base64
   end

   def remember
     self.remember_token = User.new_token
     self.update_attribute(:remember_digest,
       User.digest(remember_token))
   end

   def forget
     self.update_attribute(:remember_digest, nil)
   end

   # 渡されたトークンがダイジェストと一致したらtrueを返す
   def authenticated?(remember_token)
     return false if remember_digest.nil?
     BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
   end
 end
