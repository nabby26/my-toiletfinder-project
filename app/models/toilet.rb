require "google/cloud/datastore"
require 'carrierwave/orm/activerecord'
class Toilet < ApplicationRecord
    attr_accessor :id, :title, :location, :description, :parentsRoom, :gender_neutral, :disabled_opt, :image_url, :toilet_photo
    mount_uploader :image_url, PhotoUploader

    # Return a Google::Cloud::Datastore::Dataset for the configured dataset.
    # The dataset is used to create, read, update, and delete entity objects.
    def self.dataset
        @dataset ||= Google::Cloud::Datastore.new(
            project: Rails.application.config.database_configuration[Rails.env]["dataset_id"]
        )
    end

    # [START query]
    # Query Toilet entities from Cloud Datastore.
    #
    # returns an array of Toilet query results and a cursor
    # that can be used to query for additional results.
    def self.query options = {}
        query = Google::Cloud::Datastore::Query.new
        query.kind "Toilet"
        query.cursor options[:cursor] if options[:cursor]

        results = dataset.run query
        toilets   = results.map {|entity| Toilet.from_entity entity }

        if options[:limit] && results.size == options[:limit]
            next_cursor = results.cursor
        end

        return toilets, next_cursor
    end
    # [END query]

    # [START from_entity]
    def self.from_entity entity
        toilet = Toilet.new
        toilet.id = entity.key.id
        entity.properties.to_hash.each do |name, value|
            toilet.send "#{name}=", value if toilet.respond_to? "#{name}="
        end
        toilet
    end
    # [END from_entity]

    # [START find]
    # Lookup Toilet by ID.  Returns Toilet or nil.
    def self.find id
        query    = Google::Cloud::Datastore::Key.new "Toilet", id.to_i
        entities = dataset.lookup query

        from_entity entities.first if entities.any?
    end
    # [END find]

    # [START validations]
    # Add Active Model validation support to Book class.
    include ActiveModel::Validations
  
    validates :title, presence: true
    validates :location, presence: true
    # [END validations]

    # [START save]
    # Save the Toilet to Datastore.
    # @return true if valid and saved successfully, otherwise false.
    def save
    if valid?
        entity = to_entity
        Toilet.dataset.save entity
        self.id = entity.key.id
        true
    else
        false
    end
    end
    # [END save]

    # [START to_entity]
    # ...
    def to_entity
        entity                 = Google::Cloud::Datastore::Entity.new
        entity.key             = Google::Cloud::Datastore::Key.new "Toilet", id
        entity["title"]        = title
        entity["location"]       = location
        entity["description"]       = description
        entity["parentsRoom"]       = parentsRoom == "1" ? true : false
        entity["gender_neutral"]       = gender_neutral == "1" ? true : false
        entity["disabled_opt"]       = disabled_opt == "1" ? true : false
        entity
    end
    # [END to_entity]

    # [START update]
    # Set attribute values from provided Hash and save to Datastore.
    def update attributes
        attributes.each do |name, value|
            send "#{name}=", value if respond_to? "#{name}="
        end
        save
    end
    # [END update]

   # [START destroy]
    def destroy
     Toilet.dataset.delete Google::Cloud::Datastore::Key.new "Toilet", id
    end
  # [END destroy]

  after_commit :upload_image, if: :toilet_photo
  def upload_image
    image = StorageBucket.files.new(
      key: "toilet_photo/#{id}/#{toilet_photo.original_filename}",
      body: toilet_photo.read,
      public: true
    )
  
    image.save
  
    update_columns image_url: image.public_url
  end

  before_destroy :delete_image, if: :image_url
  def delete_image
    bucket_name = StorageBucket.key
    image_uri   = URI.parse image_url
  
    if image_uri.host == "#{bucket_name}.storage.googleapis.com"
      # Remove leading forward slash from image path
      # The result will be the image key, eg. "cover_images/:id/:filename"
      image_key = image_uri.path.sub("/", "")
      image     = StorageBucket.files.new key: image_key
  
      image.destroy
    end
  end
  
  before_update :update_image, if: :toilet_photo
  def update_image
    delete_image if image_url?
    upload_image
  end

##################

  def persisted?
    id.present?
  end   

end
