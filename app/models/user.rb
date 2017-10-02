require "google/cloud/datastore"
class User < ApplicationRecord
  attr_accessor :id, :name, :email, :password_digest, :admin

  # Return a Google::Cloud::Datastore::Dataset for the configured dataset.
  # The dataset is used to create, read, update, and delete entity objects.
  def self.dataset
    @dataset ||= Google::Cloud::Datastore.new(
      project: Rails.application.config.database_configuration[Rails.env]["dataset_id"]
      )
  end

  # Lookup User by ID.  Returns User or nil.
  def self.find id
    query    = Google::Cloud::Datastore::Key.new "User", id.to_i
    entities = dataset.lookup query

    from_entity entities.first if entities.any?
  end

  # Add Active Model validation support to User class.
  include ActiveModel::Validations

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
  
  # Save the book to Datastore.
  # @return true if valid and saved successfully, otherwise false.
  def save
    if valid?
      entity = to_entity
      User.dataset.save entity
      self.id = entity.key.id
      true
    else
      false
    end
  end

  # Set attribute values from provided Hash and save to Datastore.
  def update attributes
    attributes.each do |name, value|
      send "#{name}=", value if respond_to? "#{name}="
    end
    save
  end

  def destroy
    User.dataset.delete Google::Cloud::Datastore::Key.new "User", id
  end


end
