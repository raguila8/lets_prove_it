module Reputation
  class UpdateReputation < UpdateReputationBase
    def call
      send("after_" + @action.to_s)
    end

    private

      def after_like
        if @acted_on_type == "Problem"
          @recipient.update(reputation: @recipient.reputation += 5)
        elsif @acted_on_type == "Proof"
          @recipient.update(reputation: @recipient.reputation += 10)
        elsif @acted_on_type == "Comment"
          @recipient.update(reputation: @recipient.reputation += 2)
        end
      end

      def after_dislike
        if @acted_on_type == "Problem"
          @recipient.assign_attributes(reputation: @recipient.reputation -= 2)
        elsif @acted_on_type == "Proof"
          @recipient.assign_attributes(reputation: @recipient.reputation -= 2)
        elsif @acted_on_type == "Comment"
          @recipient.assign_attributes(reputation: @recipient.reputation -= 1)
        end

        if @acted_on_type != "Comment"
          @actor.assign_attributes(reputation: @actor.reputation -= 1)
          @actor.reputation < 0 ? @actor.update(reputation: 0) : @actor.save
        end
        @recipient.reputation < 0 ? @recipient.update(reputation: 0) : @recipient.save

      end

      def after_unlike
        if @acted_on_type == "Problem"
          @recipient.assign_attributes(reputation: @recipient.reputation -= 5)
        elsif @acted_on_type == "Proof"
          @recipient.assign_attributes(reputation: @recipient.reputation -= 10)
        elsif @acted_on_type == "Comment"
          @recipient.assign_attributes(reputation: @recipient.reputation -= 2)
        end

        @recipient.reputation < 0 ? @recipient.update(reputation: 0) : @recipient.save

      end

      def after_undislike
        if @acted_on_type == "Problem"
          @recipient.update(reputation: @recipient.reputation += 2)
        elsif @acted_on_type == "Proof"
          @recipient.update(reputation: @recipient.reputation += 2)
        elsif @acted_on_type == "Comment"
          @recipient.update(reputation: @recipient.reputation += 1)
        end

        if @acted_on_type != "Comment"
          @actor.update(reputation: @actor.reputation += 1)
        end

      end

      def after_spam_or_offensive_takedown
        if %w(Proof Problem).include? @acted_on_type
          @recipient.assign_attributes(reputation: @recipient.reputation -= 100)
          @recipient.reputation < 0 ? @recipient.update(reputation: 0) : @recipient.save
        end
      end
  end
end
