module Deletion
  class SoftDeleteBase
    def initialize(params)
      @deleted_by = params[:deleted_by]
      @deleted_for = params[:deleted_for]
      resource = params[:resource]
      @resource_type = resource.class.name

      @problem = params[:resource] if @resource_type == "Problem"
      @proof = params[:resource] if @resource_type == "Proof"
      @comment = params[:resource] if @resource_type == "Comment"
      @user = params[:resource] if @resource_type == "User"
      @version = params[:resource] if @resource_type == "Version"
      @topic = params[:topic] if @resource_type == "Topic"
    end
  end
end
