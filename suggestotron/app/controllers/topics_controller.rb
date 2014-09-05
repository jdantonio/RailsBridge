require 'functional'

class TopicsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_topic, only: [:show, :edit]

  # GET /topics
  def index
    @topics = TopicService.all_topics_by_vote_count
  end

  # GET /topics/1
  def show
  end

  # GET /topics/new
  def new
    @topic = Functional::FinalStruct.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  def create
    result = TopicService.create_topic(topic_params)

    if result.fulfilled?
      redirect_to topics_path, notice: 'Topic was successfully created.'
    else
      @topic = topic_for_form
      @errors = result.reason
      render action: 'new'
    end
  end

  # PATCH/PUT /topics/1
  def update
    result = TopicService.update_topic(topic_id, topic_params)

    if result.fulfilled?
      redirect_to topics_path, notice: 'Topic was successfully updated.'
    else
      @topic = topic_for_form(id: topic_id)
      @errors = result.reason
      render :edit
    end
  end

  # DELETE /topics/1
  def destroy
    TopicService.delete_topic(topic_id)
    redirect_to topics_url, notice: 'Topic was successfully destroyed.'
  end

  # POST /topics/1/upvote
  def upvote
    result = TopicService.upvote_topic(current_user.id, topic_id)
    redirect_to(topics_path, notice: result.reason)
  end

  private

  def topic_for_form(other_params = {})
    Functional::ValueStruct.new(topic_params.merge(other_params))
  end

  def set_topic
    @topic = TopicService.find_by_id(topic_id)
  end

  def topic_id
    params.require(:id).to_i
  end

  def topic_params
    params.require(:topic).permit(:title, :description)
  end
end
