module HelpCenterHelper
  def help_center_categories
    ["General", "Problems", "Reputation", "Privileges", "Proofs", "Account"]
  end

  def help_center_articles(category)
    case category
    when "General"
      ["What Is The Expected Behavior?", "How Do I Write Math On My Posts?",
       "Why Can People Edit My Posts?", "How Can A Post Be Deleted?"]
    when "Problems"
      ["What Are Topics And How Do I Use Them?", 
       "How Do I Write A Good Problem?", 
       "How Do I Find Problems That I Am Interested In?"]
    when "Reputation"
      ["What Is Reputation And How Do I Earn It?", "What Are Badges?"]
    when "Privileges"
      ["Create Posts", "Upvote", "Comment", "Downvote", "Report", 
       "Edit Posts", "Moderator Tools"]
    when "Proofs"
      ["How Do I Write A Good Proof?", "Can I Prove My Own Problem?", 
       "Why And How Has My Proof Been Deleted?"]
    when "Account"
      ["I Forgot My Password: How Do I Reset It?", 
       "How Do I Delete My Account?", "How Do I Create An Account?", 
       "Why Should I Create An Account?"]
    end
  end

  def is_privilege_category?(category)
    category == "Privileges"
  end

  def privilege_reputation(article)
    case article
    when "Create Posts"
      '(0)'
    when "Upvote"
      '(10)'
    when "Comment"
      '(50)'
    when "Downvote"
      '(100)'
    when "Report"
      '(300)'
    when "Edit Posts"
      '(1500)'
    when "Moderator Tools"
      '(7500)'
    end
  end
end
