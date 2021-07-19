namespace :data do
  desc "load sample data"
  task load_samples: :environment do |t, args|
    number_of_lines = `wc -l test_urls.txt`.to_i

    progressbar = ProgressBar.create(title: "Loading Sample Data", total: number_of_lines)
    File.readlines("test_urls.txt").each do |url|
      url = url.strip!
      next if url.blank?
      # This is copied straight from ApplicationController, if that becomes a problem we'll refactor
      # later

      # Load all models so we can inspect them
      Zeitwerk::Loader.eager_load_all

      # Get all models conforming to ApplicationRecord, and then check if they implement the magic
      # function.
      models = ApplicationRecord.descendants.select do |model|
        if model.respond_to? :can_handle_url?
          model.can_handle_url?(url)
        end
      end

      # We'll always choose the first one
      model = models.first
      model.create_from_url(url)

      progressbar.increment
    end
  end
end
