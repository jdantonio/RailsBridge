require 'functional'
require 'hamster'

TopicRecord = Functional::Record.new(
  :id, :title, :description, :created_at, :updated_at
)

module TopicService
  extend self

  def all_topics
    Topic.includes(:votes).reduce(Hamster.vector) do |memo, topic|
      memo.add(
        Functional::ValueStruct.new(topic.attributes.merge(vote_count: topic.votes.count))
      )
    end
  end

  def create_topic(attributes = {})
    topic = Topic.new(attributes)
    if topic.save
      Functional::Either.value(topic.freeze)
    else
      Functional::Either.reason(Hamster.vector(*topic.errors))
    end
  end

  def update_topic(id, attributes = {})
    topic = Topic.find(id)
    if topic.update(attributes)
      Functional::Either.value(topic.freeze)
    else
      Functional::Either.reason(Hamster.vector(*topic.errors))
    end
  rescue ActiveRecord::RecordNotFound => ex
    Functional::Either.reason(Hamster.vector(ex.message))
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
