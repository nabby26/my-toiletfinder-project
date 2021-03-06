require "google/cloud/datastore"

class User < ApplicationRecord
  attr_accessor :id, :name, :email, :password, :admin

  # Return a Google::Cloud::Datastore::Dataset for the configured dataset.
  # The dataset is used to create, read, update, and delete entity objects.
  def self.dataset
    @dataset ||= Google::Cloud::Datastore.new(
      project: Rails.application.config.database_configuration[Rails.env]["dataset_id"]
      )
  end
  
  # [START from_entity]
  def self.from_entity entity
    user = User.new
    user.id = entity.key.id
    entity.properties.to_hash.each do |name, value|
      user.send "#{name}=", value if user.respond_to? "#{name}="
    end
    user
  end
  # [END from_entity]


  # Lookup User by ID.  Returns User or nil.
  def self.find id
    query    = Google::Cloud::Datastore::Key.new "User", id.to_i
    entities = dataset.lookup query

    from_entity entities.first if entities.any?
  end


  #Lookup User by email. returns User or nil
  def self.find_by_email email
    query = Google::Cloud::Datastore::Query.new
    query.kind("User").
      where("email", "=", email)

    result = dataset.run query
    from_entity result.first if result.any?
  end
  
  # Add Active Model validation support to User class.
  include ActiveModel::Validations

  before_save { self.email = email.downcase } 

  validates :name,  presence: true, length: { maximum: 50 }

  #Checking email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

   validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }


  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  # [START to_entity]
  # ...
  def to_entity
    entity                 = Google::Cloud::Datastore::Entity.new
    entity.key             = Google::Cloud::Datastore::Key.new "User", id
    entity["name"]         = name
    entity["email"]        = email
    entity["password"]     = password 
    entity["admin"]        = admin if admin
    entity
  end
  # [END to_entity]

  
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