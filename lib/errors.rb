module Errors

  class CustomError < StandardError
    attr_reader :status, :error, :message

    def initialize(_error=nil, _status=nil, _message=nil)
      @error = _error || 422
      @status = _status || :unprocessable_entity
      @message = _message || 'Something went wrong'
    end

    def fetch_json
      Helpers::Render.json(error, message, status)
    end

  end

  class ProblemHasNoTopicsError < CustomError
    
    def initialize()
      super(422, :unprocessable_entity, "Problem needs to have at least one topic")
      @field = "tags"
    end
  end

  class ImagesFieldInvalid < CustomError
    def initialize()
      super(422, :unprocessable_entity, "Image field is invalid")
      @field = "problem-content"
    end
  end


  module ErrorHandler
    def errors
      @errors = []
    end

=begin
    def self.included(clazz)
      clazz.class_eval do
        
        rescue ProblemHasNoTopicsError => e
          @errors.push(e)

        rescue ImagesFieldInvalid => e
          @errors.push(e)

        rescue ActiveRecord::RecordInvalid => e
          @errors.push(e)
=end
=begin
        rescue_from CustomError do |e|
          @error = e.message
          flash.now[:custom_error] = e.message
        end
      end
    end
=end
  end
end
