class User < ApplicationRecord
  before_save { self.email = email.downcase } 

  validates :name,  presence: true, length: { maximum: 50 }

  #Checking email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

   # validates :email, presence: true, length: { maximum: 255 },
   #                  format: { with: VALID_EMAIL_REGEX },
   #                  uniqueness: { case_sensitive: false }

  #Admin login validation 
  validates :email, 
    format: {with: /\b(admin)\b/},
    uniqueness: true,
    :if => Proc.new {|c| c.admin == true}

   validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }, 
                    :unless => Proc.new {|c| c.admin == true}
  #-------------------------------------------------

  #Checking password
  has_secure_password

  validates :password, 
    format: {with: /\b(password)\b/},
    :if => Proc.new {|c| c.admin == true}

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true,
    :unless => Proc.new {|c| c.admin == true}
  #-------------------------------------------------

  # validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  # VALID_PASSWORD_REGEX = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%]).{8,}/

   # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  


end
