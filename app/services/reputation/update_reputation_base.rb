module Reputation
  class UpdateReputationBase
    def initialize(params)
      @action = params[:action]
      @acted_on = params[:acted_on] 
      @acted_on_type = @acted_on.class.name
      @recipient = @acted_on.user

      if @action != :spam_or_offensive_takedown
        @actor = params[:actor]
      end
    end
  end
end
