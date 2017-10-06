class Feedback < ApplicationRecord

	attr_accessor :id, :comment, :overall, :cleanliness, :odour, :safety, :toilet_id, :user_id

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
	  	feedback = Feedback.new
	  	feedback.id = feedback.key.id
	  	entity.properties.to_hash.each do |name, value|
	  		feedback.send "#{name}=", value if feedback.respond_to? "#{name}="
	  	end
	  	feedback
	  end
  # [END from_entity]

    # Lookup Feedback by ID.  Returns Feedback or nil.
    def self.find id
    	query    = Google::Cloud::Datastore::Key.new "Feedback", id.to_i
    	entities = dataset.lookup query

    	from_entity entities.first if entities.any?
    end


    # [START from_entity]
    def self.create_hash entity
      feedback = Feedback.new
      # feedback.id = feedback.key.id
      entity.properties.to_hash.each do |name, value|
        feedback.send "#{name}=", value if feedback.respond_to? "#{name}="
      end
      feedback
    end
  # [END from_entity]

    # [START find]
    # Lookup Toilet by toilet ID.  Returns Toilet or nil.
    def self.find_toilet_feedback toilet_id
     query = Google::Cloud::Datastore::Query.new
     query.kind("Feedback").
     where("toilet_id", "=", toilet_id.to_s)

     result = dataset.run query
     feedback = result.map {|entity| Feedback.create_hash entity }
     return feedback
   end
    # [END find]

    # [START find]
    # Lookup Toilet by ID.  Returns Toilet or nil.
    def self.find_overall_rating toilet_id
     query = Google::Cloud::Datastore::Query.new
     query.kind("Feedback").
     where("toilet_id", "=", toilet_id.to_s)

     result = dataset.run query
     feedbacks = result.map {|entity| Feedback.create_hash entity }
     if feedbacks.none?
      return nil
     end
     count = 0
     sum = 0 
      feedbacks.each do |feedback|
        count += 1
        sum += feedback.overall.to_i
      end 
     return sum.to_f/count
   end
    # [END find]


    # [START to_entity]
  # ...
  def to_entity
  	entity                 = Google::Cloud::Datastore::Entity.new
  	entity.key             = Google::Cloud::Datastore::Key.new "Feedback", id
  	entity["comment"]      = comment
  	entity["overall"]      = overall 
  	entity["cleanliness"]  = cleanliness
  	entity["odour"]        = odour
  	entity["safety"]       = safety
  	entity["user_id"]      = user_id
  	entity["toilet_id"]    = toilet_id
  	entity
  end
  # [END to_entity]




  include ActiveModel::Validations

  VALID_RATING_REGEX = "/[12345]/"

  validates :comment,  presence: true
  validates :toilet_id, presence: true
  validates :user_id, presence: true
	# validates :overall, numericality: { only_integer: true, less_than_or_equal_to: 5},  presence: true
	validates :cleanliness, numericality: { only_integer: true, less_than_or_equal_to: 5 },  presence: true
	validates :odour, numericality: { only_integer: true, less_than_or_equal_to: 5 },  presence: true
	validates :safety, numericality: { only_integer: true, less_than_or_equal_to: 5 },  presence: true
    # validates :wait_time, numericality: { only_integer: true, less_than_or_equal_to: 30 }
    # validates :check_in

  # Save the book to Datastore.
  # @return true if valid and saved successfully, otherwise false.
  def save
  	if valid?
  		entity = to_entity
  		Feedback.dataset.save entity
  		self.id = entity.key.id
  		true
  	else
  		false
  	end
  end

end

