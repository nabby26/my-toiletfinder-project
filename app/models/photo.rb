class Photo < ApplicationRecord
    attr_accessor :id, :caption, :photo_url, :user_id, :toilet_id, :created_at

    mount_uploader :photo_url, PhotoUploader

    # Return a Google::Cloud::Datastore::Dataset for the configured dataset.
	# The dataset is used to create, read, update, and delete entity objects.
	def self.dataset
		@dataset ||= Google::Cloud::Datastore.new(
			project: Rails.application.config.
			database_configuration[Rails.env]["dataset_id"]
			)
    end
    
	# [START from_entity]
	def self.from_entity entity
        photo = Photo.new
        photo.id = photo.key.id
        entity.properties.to_hash.each do |name, value|
            photo.send "#{name}=", value if photo.respond_to? "#{name}="
        end
        photo
    end
    # [END from_entity]

    # Lookup Photo by ID.  Returns Photo or nil.
    def self.find id
    	query    = Google::Cloud::Datastore::Key.new "Photo", id.to_i
    	entities = dataset.lookup query

    	from_entity entities.first if entities.any?
    end

    # [START create_hash]
    def self.create_hash entity
      photo = Photo.new
      entity.properties.to_hash.each do |name, value|
        feedback.send "#{name}=", value if feedback.respond_to? "#{name}="
      end
      feedback
    end
  # [END create_hash]

    # [START find]
    # Lookup Photo by toilet ID.  Returns Toilet or nil.
    def self.find_toilet_Photo toilet_id
     query = Google::Cloud::Datastore::Query.new
     query.kind("Photo").
     where("toilet_id", "=", toilet_id.to_s)

     result = dataset.run query
     feedback = result.map {|entity| Feedback.create_hash entity }
     return feedback
    end
   # [END find]

  # [START to_entity]
    def to_entity
        entity                 = Google::Cloud::Datastore::Entity.new
        entity.key             = Google::Cloud::Datastore::Key.new "Photo", id
        entity["caption"]      = caption
        # entity["photo_url"]      = photo_url 
        entity["user_id"]      = user_id
        entity["toilet_id"]    = toilet_id
        entity["created_at"]  = created_at
        entity
    end
  # [END to_entity]

  include ActiveModel::Validations
  ## Validation goes here ...

  # Save the Photo to Datastore.
  # @return true if valid and saved successfully, otherwise false.
  def save
    if valid?
        entity = to_entity
        Photo.dataset.save entity
        self.id = entity.key.id
        true
    else
        false
    end
end

end
