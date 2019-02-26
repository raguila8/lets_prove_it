module ProblemPersistence
  class ProblemCreationInteractor
    #include Errors::ErrorHandler

    def self.call(params)
      interactor = new(params)
      interactor.run
      interactor
    end

    attr_reader :errors

    def initialize(params)
      @params = params
    end 

    def success?
      @success
    end

    def run
      @problem_service = ProblemCreationService.new(params) 

    # NEED TO DO
    rescue Errors::ImagesFieldInvalid
      @success = false

    rescue ActiveRecord::RecordInvalid => exception
      @errors = exception.record.errors
      @success = false
    else
      @success = true
    end

    def problem
      @problem_service.problem
    end

    private

    attr_reader :params
  end
end
