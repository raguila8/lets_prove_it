module Search
  class SearchInteractor
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

    def results
      return @service.results
    end

    def query
      return @service.query
    end

    def run
      @service = SearchService.new(params)

    # NEED TO DO
    rescue ActiveRecord::RecordInvalid => exception
      @errors = exception.record.errors
      @success = false
    else
      @success = true
    end

    private

    attr_reader :params

  end
end
