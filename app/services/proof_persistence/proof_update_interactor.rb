module ProofPersistence
  class ProofUpdateInteractor
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
      @proof_service = ProofUpdateService.new(params) 

    # NEED TO DO
    rescue Errors::ImagesFieldInvalid
      @success = false

    rescue ActiveRecord::RecordInvalid => exception
      @errors = exception.record.errors
      @success = false
    else
      @success = true
    end

    def proof
      @proof_service.proof
    end

    private

    attr_reader :params

  end
end
