
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
        photo.send "#{name}=", value if photo.respond_to? "#{name}="
      end
      photo
      
    end
  # [END create_hash]

    # [START find]
    # Lookup Photo by toilet ID.  Returns Toilet or nil.
    def self.find_toilet_photo toilet_id
     query = Google::Cloud::Datastore::Query.new
     query.kind("Photo").
     where("toilet_id", "=", toilet_id.to_s)

     result = dataset.run query
     photo = result.map {|entity| Photo.create_hash entity } 
     return photo
    end
   # [END find]

  # [START to_entity]
    def to_entity
        entity                 = Google::Cloud::Datastore::Entity.new
        entity.key             = Google::Cloud::Datastore::Key.new "Photo", id
        entity["caption"]      = caption
        entity["photo_url"]      = @file_url 
        entity["user_id"]      = user_id
        entity["toilet_id"]    = toilet_id
        entity["created_at"]  = created_at
        entity
    end
  # [END to_entity]

  include ActiveModel::Validations
  ## Validation goes here ...


  # Upload Photo Here
  def upload_file image 
    storage = Google::Cloud::Storage.new(
        project: "my-toiletfinder-project",
        keyfile: "#{Rails.root}/credential/ToiletFinder-9ede96ffc554.json"
      )
      
      bucket = storage.bucket "toilet-photos"
      file = bucket.create_file image.file.path,
       "#{toilet_id}/#{user_id}/#{id}",
       acl: `public`
      @file_url = file.public_url

  end

  # Save the Photo to Datastore.
  # @return true if valid and saved successfully, otherwise false.
  def save
    if valid?
        #Upload photos here ..
        upload_file photo_url

        entity = to_entity
        Photo.dataset.save entity
        self.id = entity.key.id
        true
    else
        false
    end
end

end
