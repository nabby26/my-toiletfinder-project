class Feedback < ApplicationRecord

	attr_accessor :id, :comment, :overall, :cleanliness, :odour, :safety

	# Return a Google::Cloud::Datastore::Dataset for the configured dataset.
	# The dataset is used to create, read, update, and delete entity objects.
	def self.dataset
		@dataset ||= Google::Cloud::Datastore.new(
			project: Rails.application.config.
			database_configuration[Rails.env]["dataset_id"]
			)
	end


	include ActiveModel::Validations

	VALID_RATING_REGEX = "/[12345]/"

	validates :comment
	validates :overall, numericality: { only_integer: true, less_than_or_equal_to: 5}
	validates :cleanliness, numericality: { only_integer: true, less_than_or_equal_to: 5 }
    validates :odour, numericality: { only_integer: true, less_than_or_equal_to: 5 }
    validates :safety, numericality: { only_integer: true, less_than_or_equal_to: 5 }
    # validates :wait_time, numericality: { only_integer: true, less_than_or_equal_to: 30 }
    # validates :check_in

	belongs_to :users
    belongs_to :toilets
end
