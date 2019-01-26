module HelpCenterHelper
  def help_center_categories
    ["General", "Problems", "Reputation", "Privileges", "Proofs", "Account"]
  end

  def help_center_articles(category)
    case category
    when "General"
      ["What Is The Expected Behavior?", "How Do I Write Math On My Posts?",
       "Why Can People Edit My Posts?", "Can I Add A Topic?", 
        "How Is A Post Deleted?", "What If I Need More Help?"]
    when "Problems"
      ["What Are Tags/Topics And How Do I Use Them?", 
       "How Do I Write A Good Problem?", 
       "How Do I Find Problems That I Am Interested In?"]
    when "Reputation"
      ["What Is Reputation And How Do I Earn It?", "What Are Badges?"]
    when "Privileges"
      ["Create Posts", "Upvote", "Comment", "Downvote", "Report", 
       "Edit Problems And Proofs", "Add A Topic", "Become A Mod"]
    when "Proofs"
      ["How Do I Write A Good Proof?", "Can I Prove My Own Problem?", 
       "Why And How Has My Proof Been Deleted?"]
    when "Account"
      ["I Forgot My Password: How Do I Reset It?", 
       "How Do I Delete My Account?", "How Do I Create An Account?", 
       "Why Should I Create An Account?"]
    end
  end
end
