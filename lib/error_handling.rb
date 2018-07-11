module Error

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

  class ProblemHasNoTopicsError < CustomeError
    
    def initialize()
      super(422, :unprocessable_entity, "Problem needs to have at least one topic")
    end
  end

  class ImagesFieldInvalid < StandardError
    def initialize()
      super(422, :unprocessable_entity, "Image field is invalid")
    end
  end


  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from CustomError do |e|
          @error = e.message
          flash.now[:custom_error] = e.message
        end
      end
    end
  end
end
