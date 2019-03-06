module ProblemsHelper
  def related_problems_widget_items
    html = ""
    @problem.related_problems.each_with_index do |problem, index|
      html += "<div class='' style='padding: 10px; #{'border-top: 1px solid #ddd;' if index != 0 }'><a href='/problems/#{problem.id}'><h6 class='main-link' style='font-weight: 600;'>#{problem.title}</h6></a><span style='color: #777; font-size: .8em; line-height: 1.428;'>#{problem.created_at.strftime('%B %d, %Y')}</span></div>"
    end
    return html.html_safe
  end

  def image_preview(problem)
    preview_image = problem.images.first
    return "background-image: url('#{preview_image.image_data.url}');" if !preview_image.nil?
  end

  def get_stream_item_class(problem)
    problem.has_image_to_preview? ? "col-xs-8 mr-24 pr-0" : "col-xs-12"
  end

  def bookmark_link(problem, options={})
    if signed_in? and current_user != problem.user
      is_bookmarked = (current_user.bookmarked?(problem))
      title = (is_bookmarked ? 'Unbookmark problem' : 'Bookmark problem')
      bookmark_icon = (is_bookmarked ? 'fa-bookmark' : 'fa-bookmark-o')
      action = (is_bookmarked ? 'unbookmark' : 'bookmark')
      method = (is_bookmarked ? 'delete' : 'post')
      klass = (options.key?(:class) ? options[:class] : "fontSize-20 greyLink headerFont")

      content = "<a href='/problems/#{problem.id}/#{action}' class='#{klass}' data-remote='true' data-method='#{method}' title='#{title}'><i class='fa #{bookmark_icon}'></i></a>"
      content.html_safe
    end
  end

  def popular_problems_widget_title
    if controller_name == "topics"
      "Popular In #{@topic.name.titleize}"
    elsif controller_name == "problems"
      "Popular Problems"
    end
  end

  def popular_problems
    if controller_name == "problems" 
      problems = Problem.where('created_at >= ?', 1.week.ago).order(:cached_votes_score).limit(5)
      i = 2
      while problems.count < 4 do
        problems = Problem.where('created_at >= ?', i.week.ago).order(:cached_votes_score).limit(5)
        i += 1
      end
    elsif controller_name == "topics"
      problems = @topic.problems.where('problems.created_at >= ?', 4.week.ago).order(:cached_votes_score).limit(5)
      i = 5
      while problems.count < 1 do
        problems = @topic.problems.where('problems.created_at >= ?', i.week.ago).order(:cached_votes_score).limit(5)
        i += 1
      end
    end
    return problems
  end


end
