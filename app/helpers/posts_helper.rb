module PostsHelper
  def edit_button(model)
    if signed_in? 
      if model.class.name == "Problem" or model.class.name == 'Proof'
        if model.user == current_user or current_user.has_edit_privileges?
          html = "<a class='greyLink headerFont float-right mr-18' href='/#{model.class.name.downcase.pluralize}/#{model.id}/edit' title='Edit #{model.class.name.downcase}'><i class='fa fa-pencil-square-o'></i></a>"
        end
      elsif model.class.name == "Comment"
        html = "<a class='greyLink headerFont float-right' data-remote='true' href='#' title='Edit comment'><i class='fa fa-pencil-square-o mr-5'></i></a>"
      end
      html.html_safe
    end
  end
end
