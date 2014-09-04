class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit]

  # GET /topics
  # GET /topics.json
  def index
    @topics = TopicService.all_topics
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    result = TopicService.create_topic(topic_params)

    respond_to do |format|
      if result.fulfilled?
        format.html { redirect_to topics_path, notice: 'Topic was successfully created.' }
        format.json { render action: 'show', status: :created, location: result.value }
      else
        format.html { render action: 'new' }
        format.json { render json: result.reason, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    result = TopicService.update_topic(topic_id, topic_params)

    respond_to do |format|
      if result.fulfilled?
        format.html { redirect_to topics_path, notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: result.value }
      else
        format.html { render :edit }
        format.json { render json: result.reason, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    TopicService.delete_topic(topic_id)
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'Topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    result = TopicService.upvote_topic(topic_id)
    redirect_to(topics_path, notice: result.reason)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_id
    params.require(:id).to_i
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def topic_params
    params.require(:topic).permit(:title, :description)
  end
end
