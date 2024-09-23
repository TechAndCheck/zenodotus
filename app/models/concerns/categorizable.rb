module Categorizable
  extend ActiveSupport::Concern
  extend T::Sig

  @@archive_categories = YAML.load_file(Rails.root.join("lib", "assets", "categories.yml"))["categories"]

  # AVAILABLE_CATEGORIES = %w[Politics Sports Entertainment Technology]
  CATEGORIZE_PROMPT = "Using this list of categories: #{@@archive_categories.join(",")}\ categorize the\
  following statment into the\
  categories, ordering them by most relevant. If there are no matches respond with no text at all. Return only the category names separated by commas and nothing else: "

  class_methods do
    def property_to_categorize(property = nil, &block)
      # A nifty trick to auto add acts_as_taggable_on(:categories) to the model
      instance_eval(&Proc.new { acts_as_taggable_on(:categories) })
      @@property = property # This is the property that will be used to categorize the model instance
      @@property_block = block # This is the block that the return will be used to categorize the model instance
    end
  end

  included do
    # Categorize the ArchiveItem based on the content of the ArchiveItem
    # This uses OLLAMA_CLIENT to categorize the ArchiveItem
    def categorize
      prompt = categorize_prompt
      return if prompt.nil?

      result = OLLAMA_CLIENT.generate(
        { model: "gemma2",
          prompt: prompt,
          stream: false }
      )

      new_categories = result.first["response"].strip.split(",").map(&:strip)
      new_categories = new_categories[0..3] if new_categories.length > 4

      new_categories.each do |category|
        self.category_list.add(category) if @@archive_categories.include?(category)
      end
    end

    def categorize!
      # First we remove all the categories on the ArchiveItem
      clear_categories!

      self.categorize
      self.save!
      self.reload
    end

    def clear_categories!
      self.categories.each { |category| self.category_list.remove(category.name) }
      self.save!
      self.reload
    end
  end

private

  def content_to_categorize
    return instance_eval(&@@property_block) if @@property.nil?
    self.send(@@property)
  end

  def categorize_prompt
    content_to_categorize_final = content_to_categorize
    return if content_to_categorize_final&.empty?

    "#{CATEGORIZE_PROMPT} \"#{content_to_categorize_final}\""
  end
end
