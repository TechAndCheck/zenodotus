module MediaVault::AuthorsHelper
  # Takes an instance of a model like Sources::InstagramUser
  # and returns a string like "instagram_user"
  def underscore_author_model(model_instance)
    model_instance.class.to_s.gsub("Sources::", "").underscore
  end
end
