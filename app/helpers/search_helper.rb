module SearchHelper
  def search_input(query)
    if !query.nil? and query.length > 0
      "<input type='search' placeholder='Search' class='darkType headerFont' id='site-search' value='#{query}' autofocus>".html_safe
    else
      "<input type='search' placeholder='Search' class='darkType headerFont' id='site-search' autofocus>".html_safe
    end
  end
end
