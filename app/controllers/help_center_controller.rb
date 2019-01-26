class HelpCenterController < ApplicationController
  include HelpCenterHelper

  before_action :category_exists,  only: [:category]
  before_action :article_exists, only: [:article] 
 
  def help
  end

  def category
  end

  def article
  end

  ########### Help Center Categories #############
=begin
  def general
  end

  def problems
  end

  def reputation
  end

  def priviliges
    #@privilige = params[:id].to_i
  end

  def proofs
  end

  def account
  end

  def mathjax_cheatsheet
  end

  def on_topics
  end

  def good_problems
  end

  def on_problem_feed
  end

  def expected_behavior
  end

  def editing_posts
  end
 
  def creating_topics
  end

  def deleting_posts
  end

  def badges
  end
=end

  private

  def category_exists
    @category = params[:category].titleize
    if !help_center_categories.include? @category
      raise ActionController::RoutingError.new('Not Found')
    end
    #lookup_context.exists?("help_center/#{@category}find")
  end

  def article_exists
    @category = params[:category].titleize
    @article = params[:article].titleize

    if !help_center_articles(@category).include? @article
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
