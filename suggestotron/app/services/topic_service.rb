require 'functional'

module TopicService
  extend self

  def all_topics_by_vote_count
    topics = Topic.includes(:votes).reduce([]) do |memo, topic|
      up = topic.votes.reduce(0){|count, vote| count + ( vote.disposition == 'up' ? 1 : 0 ) }
      down = topic.votes.count - up
      memo << Functional::ValueStruct.new(topic.attributes.merge(vote_count: topic.votes.count, up: up, down: down))
    end
    topics.sort!{|a, b| b.vote_count <=> a.vote_count }
    Functional::Tuple.new(topics)
  end

  def find_by_id(id)
    Functional::ValueStruct.new(Topic.find(id).attributes)
  end

  def create_topic(attributes = {})
    topic = Topic.new(attributes)
    if topic.save
      Functional::Either.value(Functional::ValueStruct.new(topic.attributes))
    else
      Functional::Either.reason(Functional::Tuple.new(topic.errors))
    end
  end

  def update_topic(id, attributes = {})
    topic = Topic.find(id)
    if topic.update(attributes)
      Functional::Either.value(Functional::ValueStruct.new(topic.attributes))
    else
      Functional::Either.reason(Functional::Tuple.new(topic.errors))
    end
  rescue ActiveRecord::RecordNotFound => ex
    Functional::Either.reason(Functional::Tuple.new([ex.message]))
  end

  def delete_topic(id)
    Topic.find(id).destroy
  rescue ActiveRecord::RecordNotFound => ex
    false
  end

  def upvote_topic(user_id, topic_id)
    vote_on_topic(user_id, topic_id, :up)
  end

  def downvote_topic(user_id, topic_id)
    vote_on_topic(user_id, topic_id, :down)
  end

  private

  def vote_on_topic(user_id, topic_id, disposition)
    Vote.transaction do
      vote = Vote.where(user_id: user_id, topic_id: topic_id).first
      if vote && vote.disposition != disposition.to_s
        vote.update(disposition: disposition)
      elsif vote.nil?
        Vote.create(user_id: user_id, topic_id: topic_id, disposition: disposition)
      end
    end
    Functional::Either.value(Vote.where(topic_id: topic_id).count)
  #rescue => ex
    #Functional::Either.reason(ex.message)
  end
end
