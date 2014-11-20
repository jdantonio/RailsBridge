class Topic
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_many :votes, dependent: :destroy

  field :title, :type => String
  field :description, :type => String

  validates :title, presence: true
  validates :description, presence: true
end
