module Search
  class SearchService
    attr_reader :results, :query

    def initialize(params)
      @query = (params[:query].present? ? params[:query] : nil)
      @autocomplete = (params[:autocomplete].present? ? params[:autocomplete] : false)
      call
    end

    def call
      if @query.nil?
        @results = nil
        return
      end

      @autocomplete ? autocomplete_search : search
    end

    private

    def pattern
      "%#{@query}%"
    end
  
    def autocomplete_search
      users = User.select("username AS label", "id AS id", "'Users' AS category", "CASE avatar WHEN '' THEN '/assets/avatar.png' ELSE avatar END AS image_url").where("username LIKE ?", pattern).active.limit(3)

      topics = Topic.select("name AS label", "id AS id", "'Topics' AS category").where("name LIKE ?", pattern).active.limit(3)

      problems = Problem.select("title AS label", "id AS id", "'Problems' AS category", "'/assets/no_problems_icon.png' AS image_url").where("title LIKE ?", pattern).active.limit(3)
      
      @results = users + topics + problems
    end

    def search
      @results = {}
      @results[:problems] = Problem.where("title LIKE ?", pattern).active.limit(10)
      @results[:topics] = Topic.where("name LIKE ?", pattern).active.limit(15)
      @results[:users] = User.where("username LIKE ?", pattern).active.limit(10)
    end
  end
end
