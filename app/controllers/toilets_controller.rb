require "google/cloud/storage"
class ToiletsController < ApplicationController
  before_action :set_toilet, only: [:show, :edit, :update, :destroy]
  #before_action :admin_user, only: [:index, :show, :edit, :update, :destroy]

  # GET /toilets
  # GET /toilets.json
  PER_PAGE = 6

  def index
    @toilets, @next_cursor, @curr_cursor, @prev_cursor = Toilet.query(
                                                                      limit: PER_PAGE, 
                                                                      cursor: params[:cursor], 
                                                                      prev_cursor: params[:prev_cursor]
                                                                      )
  end

  # GET /toilets/1
  # GET /toilets/1.json
  def show
    @toilet = Toilet.new.get_toilet params[:id]
    @feedbacks = Feedback.find_toilet_feedback params[:id]
    @photos = Photo.find_toilet_photo params[:id]
  end

  # GET /toilets/new
  def new
    @toilet = Toilet.new
  end

  # GET /toilets/1/edit
  def edit
    @toilet = Toilet.find params[:id]
  end

  # POST /toilets
  # POST /toilets.json
  def create
    @toilet = Toilet.new(toilet_params)
    
    respond_to do |format|
      if @toilet.save
        # Once toilets are created, create opening hours for all weekdays
        set_up_opening_hours @toilet
        format.html { redirect_to @toilet, notice: 'Toilet was successfully created.' }
        format.json { render :show, status: :created, location: @toilet }
      else
        format.html { render :new }
        format.json { render json: @toilet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /toilets/1
  # PATCH/PUT /toilets/1.json
  def update
    respond_to do |format|
      if @toilet.update(toilet_params)
        format.html { redirect_to @toilet, notice: 'Toilet was successfully updated.' }
        format.json { render :show, status: :ok, location: @toilet }
      else
        format.html { render :edit }
        format.json { render json: @toilet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /toilets/1
  # DELETE /toilets/1.json
  def destroy

    # @feedbacks = Feedback.find_toilet_feedback @toilet.id
    # @feedbacks.each do |feedback|
    #   feedback.destroy feedback
    # end 
    @toilet.destroy
    respond_to do |format|
      format.html { redirect_to toilets_url, notice: 'Toilet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_toilet
      @toilet = Toilet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def toilet_params
      # Need to calculate (backend) the long and lat from the location given
      # Make an API call to google maps and verify. If location is not valid then reject the create/update

      params.require(:toilet).permit(:title, :location, :description, :parentsRoom, 
        :gender_neutral, :disabled_opt, :female, :male, :lat, :lon).merge(public_toilet: false)
    end

    def set_up_opening_hours toilet
      @monday = OpeningHour.new(day: "Monday", open_time: nil, close_time: nil, toilet_id: toilet.id.to_s)
      @tuesday = OpeningHour.new(day: "Tuesday", open_time: nil, close_time: nil, toilet_id: toilet.id.to_s)
      @wednesday = OpeningHour.new(day: "Wednesday", open_time: nil, close_time: nil, toilet_id: toilet.id.to_s)
      @thursday = OpeningHour.new(day: "Thursday", open_time: nil, close_time: nil, toilet_id: toilet.id.to_s)
      @friday = OpeningHour.new(day: "Friday", open_time: nil, close_time: nil, toilet_id: toilet.id.to_s)
      @saturday = OpeningHour.new(day: "Saturday", open_time: nil, close_time: nil, toilet_id: toilet.id.to_s)
      @sunday = OpeningHour.new(day: "Sunday", open_time: nil, close_time: nil, toilet_id: toilet.id.to_s)
      
      @monday.save
      @tuesday.save
      @wednesday.save
      @thursday.save
      @friday.save
      @saturday.save
      @sunday.save
    end 
end
