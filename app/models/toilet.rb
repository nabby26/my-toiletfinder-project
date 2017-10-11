require "google/cloud/datastore"
require 'carrierwave/orm/activerecord'
require "google/cloud/bigquery"
class Toilet < ApplicationRecord
    attr_accessor :id, :title, :location, :description, :parentsRoom, :gender_neutral, :disabled_opt, :image,:female, :male, :lon, :lat, :public_toilet
    
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
        query.limit options[:limit]   if options[:limit]
        if options[:cursor]
            query.cursor options[:cursor] 
            curr_cursor = options[:cursor] 
        end

        if !options[:cursor]
            prev_cursor = nil
        end
        if options[:prev_cursor]
            prev_cursor = options[:prev_cursor]
        end 

        results = dataset.run query
        toilets   = results.map {|entity| Toilet.from_entity entity }

        if options[:limit] && results.size == options[:limit]
            next_cursor = results.cursor
        end

        return toilets, next_cursor, curr_cursor, prev_cursor
    end
    # [END query]

    # def self.all
    #     query = Google::Cloud::Datastore::Query.new
    #     query.kind "Toilet"

    #     results = dataset.run query
    #     toilets   = results.map {|entity| Toilet.from_entity entity }

    #     return toilets
    # end 

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

    # Add Active Model support.
    # Provides constructor that takes a Hash of attribute values.
    include ActiveModel::Model

    validates :title,  presence: true, length: { maximum: 50 }
    validates :location,  presence: true, length: { maximum: 150 }
    validates :description, length: { maximum: 100 }

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
        entity                      = Google::Cloud::Datastore::Entity.new
        entity.key                  = Google::Cloud::Datastore::Key.new "Toilet", id
        entity["title"]             = title
        entity["location"]          = location
        entity["description"]       = description
        entity["parentsRoom"]       = parentsRoom == "1" ? true : false
        entity["gender_neutral"]    = gender_neutral == "1" ? true : false
        entity["disabled_opt"]      = disabled_opt == "1" ? true : false
        entity["female"]            = female == "1" ? true : false
        entity["male"]              = male == "1" ? true : false
        entity["lon"]               = lon if lon
        entity["lat"]               = lat if lat
        entity["public_toilet"]     = public_toilet if public_toilet
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

    # BIG QUERY DATA

    # [START from_entity]
    def self.create_hash entity
      toilet = Toilet.new
      # feedback.id = feedback.key.id
      entity.each do |name, value|
        toilet.send "#{name}=", value if toilet.respond_to? "#{name}="
      end
      toilet
    end

    # [START toilet_from_big_query]
    # ...
    def get_public_toilets
        bigquery = Google::Cloud::Bigquery.new project: 
                                Rails.application.config.database_configuration[Rails.env]["dataset_id"]
        # [END build_service]

        # [START run_query]
        sql = "SELECT * FROM `my-toiletfinder-project.Toilet.PublicToilets`"
        result = bigquery.query sql

        toilets = result.map {|entity| Toilet.create_hash entity }
        # [END run_query]
        return toilets
    end
    # [END toilet_from_big_query]

    # [START toilet_from_big_query]
    # ...
    def get_toilet id
        bigquery = Google::Cloud::Bigquery.new project: "my-toiletfinder-project"
        # [END build_service]

        # [START run_query]
        sql = "SELECT * FROM `my-toiletfinder-project.Toilet.PublicToilets`" + 
                "WHERE id = (@id)"
        result = bigquery.query sql, params: { id: id }

        if result.none?
            Toilet.find id
        else
            Toilet.create_hash result.first if result.any?
        end
    end
    # [END toilet_from_big_query]


end
