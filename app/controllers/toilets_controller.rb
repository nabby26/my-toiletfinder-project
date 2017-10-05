class ToiletsController < ApplicationController
  before_action :set_toilet, only: [:show, :edit, :update, :destroy]
  #before_action :admin_user, only: [:index, :show, :edit, :update, :destroy]

  # GET /toilets
  # GET /toilets.json
  def index
    @toilets , @cursor = Toilet.query limit: 10, cursor: params[:cursor], cursor: params[:cursor]
  end

  # GET /toilets/1
  # GET /toilets/1.json
  def show
    @toilet = Toilet.find params[:id]
    @feedbacks = Feedback.find_toilet_feedback params[:id]
  end

  # GET /toilets/new
  def new
    @toilet = Toilet.new
  end

  # GET /toilets/1/edit
  def edit
  end

  # POST /toilets
  # POST /toilets.json
  def create
    @toilet = Toilet.new(toilet_params)

    respond_to do |format|
      if @toilet.save
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
      params.require(:toilet).permit(:title, :location, :description)
    end

    #Confirms admin user
    # def admin_user
    #   redirect_to(root_url) unless current_user.admin?
    # end
end
