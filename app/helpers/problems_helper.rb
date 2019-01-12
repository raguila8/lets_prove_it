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

  def bookmark_link(problem)
    is_bookmarked = (signed_in? and current_user.bookmarked?(problem))
    title = (is_bookmarked ? 'Unbookmark problem' : 'Bookmark problem')
    bookmark_icon = (is_bookmarked ? 'fa-bookmark' : 'fa-bookmark-o')
    action = (is_bookmarked ? 'unbookmark' : 'bookmark')
    method = (is_bookmarked ? 'delete' : 'post')

    content = "<a href='/problems/#{problem.id}/#{action}' class='greyLink headerFont' data-remote='true' data-method='#{method}' title='#{title}'><i class='fa #{bookmark_icon}'></i></a>"
    content.html_safe
  end
end
