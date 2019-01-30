module TopicsHelper
  def more_than_two_related_topics?
    (@related_topics = @topic.related_topics).count > 2
  end
end
