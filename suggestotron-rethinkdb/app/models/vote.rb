class Vote
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  belongs_to :topic
end
