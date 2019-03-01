module VersionsHelper
  def action_on_post(version)
    version.version_number == 1 ? "created" : "edited"
  end

  def version_content(version)
    if version.versioned_type == "Problem"
      render partial: "versions/problem_content", locals: { version: version }
    else 
      render partial: "versions/proof_content", locals: { version: version }
    end
  end
end
