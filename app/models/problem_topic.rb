class ProblemTopic < ApplicationRecord
  before_destroy :subtract_topic_cached_problems_count
  after_create :add_topic_cached_problems_count

  belongs_to :problem
  belongs_to :topic

  validates_uniqueness_of :problem_id, :scope => [:topic_id]

  private

    def add_topic_cached_problems_count
      count = self.topic.cached_problems_count
      self.topic.update(cached_problems_count: count + 1)
    end

    def subtract_topic_cached_problems_count
      count = self.topic.cached_problems_count
      self.topic.update(cached_problems_count: count - 1)
    end

end
