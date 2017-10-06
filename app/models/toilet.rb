require "google/cloud/datastore"
require 'carrierwave/orm/activerecord'
class Toilet < ApplicationRecord
    attr_accessor :id, :title, :location, :description, :parentsRoom, :gender_neutral, :disabled_opt, :image
    
    mount_uploaders :image, PhotoUploader
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

##################

  def persisted?
    id.present?
  end   

end
