require 'functional'
require 'hamster'

module TopicService
  extend self

  def all_topics_with_votes
    Topic.includes(:votes).reduce(Hamster.vector) do |memo, topic|
      memo.add(
        Functional::ValueStruct.new(topic.attributes.merge(vote_count: topic.votes.count))
      )
    end
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

  def upvote_topic(id)
    topic = Topic.find(id)
    topic.votes.create
    Functional::Either.value(topic.votes.count)
  rescue => ex
    Functional::Either.reason(ex.message)
  end
end
