class OpeningHour < ApplicationRecord
	attr_accessor :day, :open_time, :close_time, :toilet_id

	# Return a Google::Cloud::Datastore::Dataset for the configured dataset.
	# The dataset is used to create, read, update, and delete entity objects.
	def self.dataset
		@dataset ||= Google::Cloud::Datastore.new(
			project: Rails.application.config.
			database_configuration[Rails.env]["dataset_id"]
			)
	end

	# [START from_entity]
    def self.create_hash entity
      openingHour = OpeningHour.new
      openingHour.id = entity.key.id
      entity.properties.to_hash.each do |name, value|
        openingHour.send "#{name}=", value if openingHour.respond_to? "#{name}="
      end
      openingHour
      
    end
  # [END from_entity]

    # [START find]
    # Lookup Toilet by toilet ID.  Returns Toilet or nil.
    def self.find_opening id
     query = Google::Cloud::Datastore::Query.new
     query.kind("OpeningHour").
     where("toilet_id", "=", id.to_s)

     result = dataset.run query
     openingHour = result.map {|entity| OpeningHour.create_hash entity }
     return openingHour
   end
    # [END find]

    def self.get_openings id
     query = Google::Cloud::Datastore::Query.new
     query.kind("OpeningHour").
     where("toilet_id", "=", id.to_s)
     @monday = nil
     @tuesday = nil
     @wednesday = nil
     @thursday = nil
     @friday = nil
     @saturday = nil
     @sunday = nil

     result = dataset.run query
     openingHour = result.map {|entity| OpeningHour.create_hash entity }

     openingHour.each do |day|
      if day.day == "Monday"
        @monday = day
      elsif day.day == "Tuesday"
        @tuesday = day
      elsif day.day == "Wednesday"
        @wednesday = day
      elsif day.day == "Thursday"
        @thursday = day
      elsif day.day == "Friday"
        @friday = day
      elsif day.day == "Saturday"
        @saturday = day
      elsif day.day == "Sunday"
        @sunday = day
      else 
        return
      end
     end 
     return @monday, @tuesday, @wednesday, @thursday, @friday, @saturday, @sunday
   end

    def self.find_day options = {}
    	query = Google::Cloud::Datastore::Query.new
     	query.kind("OpeningHour").
     	where("toilet_id", "=", options[:toilet_id].to_s).
     	where("day", "=", options[:weekday].to_s)

     	result = dataset.run query
     	create_hash result.first if result.any?

    end 
	# [START to_entity]
  # ...
  def to_entity
  	entity                 = Google::Cloud::Datastore::Entity.new
  	entity.key             = Google::Cloud::Datastore::Key.new "OpeningHour", id
  	entity["day"]      	   = day
  	entity["open_time"]    = open_time 
  	entity["close_time"]   = close_time
  	entity["toilet_id"]    = toilet_id
  	entity
  end
  # [END to_entity]




  include ActiveModel::Validations

  validates :day, presence: true
  # validates :open_time, presence: true
  # validates :close_time, presence: true
  validates :toilet_id, presence: true

    # [START update]
    # Set attribute values from provided Hash and save to Datastore.
    def update attributes
        attributes.each do |name, value|
            send "#{name}=", value if respond_to? "#{name}="
        end
        save
    end
    # [END update]

  # Save the book to Datastore.
  # @return true if valid and saved successfully, otherwise false.
  def save
  	if valid?
  		entity = to_entity
  		OpeningHour.dataset.save entity
  		self.id = entity.key.id
  		true
  	else
  		false
  	end
  end

end
