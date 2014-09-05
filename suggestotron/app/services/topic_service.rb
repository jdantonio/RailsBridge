require 'functional'

module TopicService
  extend self

  def all_topics_by_vote_count
    topics = Topic.includes(:votes).reduce([]) do |memo, topic|
      memo << Functional::ValueStruct.new(topic.attributes.merge(vote_count: topic.votes.count))
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
    topic = Topic.find(topic_id)
    topic.votes.create(user_id: user_id)
    Functional::Either.value(topic.votes.count)
  rescue => ex
    Functional::Either.reason(ex.message)
  end
end
