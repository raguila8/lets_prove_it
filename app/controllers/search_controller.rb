class SearchController < ApplicationController
  def search
    @interactor = Search::SearchInteractor.call(self.params)
    @results = @interactor.results

    respond_to do |format|
			format.json {
				render json: {suggestions: @results }
			}

      format.html {

      }

      format.js {
        
      }
		end
  end
end
