class MediaVault::AuthorsController < MediaVaultController
  class UnsupportedPlatform < StandardError; end

  AUTHOR_PLATFORM_DEFINITIONS = {
    # platform: {
    #   author_source_model_name: "", # The bit after "Sources::" in the author model
    #   archive_item_model_name:  "", # The bit after "Sources::" in the post model
    #   author_name_method:       "", # Accessor method name for getting the author's display name
    # },
    facebook: {
      author_source_model_name: "FacebookUser",
      archive_item_model_name:  "FacebookPost",
      author_name_method:       "name",
    },
    instagram: {
      author_source_model_name: "InstagramUser",
      archive_item_model_name:  "InstagramPost",
      author_name_method:       "display_name",
    },
    twitter: {
      author_source_model_name: "TwitterUser",
      archive_item_model_name:  "Tweet",
      author_name_method:       "display_name",
    },
    youtube: {
      author_source_model_name: "YoutubeChannel",
      archive_item_model_name:  "YoutubePost",
      author_name_method:       "title",
    },
  }

  class AuthorParams < T::Struct
    const :platform, String
    const :id, String
  end

  sig { void }
  def show
    typed_params = TypedParams[AuthorParams].new.extract!(params)

    raise UnsupportedPlatform unless AUTHOR_PLATFORM_DEFINITIONS.has_key?(typed_params.platform.to_sym)
    @platform = AUTHOR_PLATFORM_DEFINITIONS[typed_params.platform.to_sym]

    author_model = Sources.const_get(@platform[:author_source_model_name])
    @author = author_model.find(typed_params.id)
    @archive_items = ArchiveItem.includes(archivable_item: [:author, :images, :videos])
                               .where(archivable_item_type: "Sources::#{@platform[:archive_item_model_name]}")
                               .select { |i| i.send(@platform[:archive_item_model_name].underscore).author == @author }

    respond_to do |format|
      format.html do; end
      format.json do
        send_data ArchiveItem.generate_json_for_export(@archive_items),
          type: "application/json",
          filename: "#{@author.send(@platform[:author_name_method]).parameterize(separator: '_')}_#{typed_params.platform}_archive.json"
      end
    end
  end
end
