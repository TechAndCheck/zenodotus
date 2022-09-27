module MediaVault::TextSearchHelper
  # Takes an instance of a model like Sources::InstagramPost
  # and returns a string like '_instagram_post'
  def search_view_for_model_instance(model_instance)
    stripped_model_name = model_instance.class.to_s.gsub("Sources::", "")
    clean_model_name = stripped_model_name.chars.map { |char| /[A-Z]/.match?(char) ? "_" + char.downcase : char }.join # replace [A-Z] with _[a-z]
    "search_result" + clean_model_name
  end
end
