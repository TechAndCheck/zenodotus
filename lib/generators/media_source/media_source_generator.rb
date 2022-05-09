# typed: ignore
class MediaSourceGenerator < Rails::Generators::NamedBase
  desc "This generator creates a new media source for collecting and archiving of content."

  source_root File.expand_path("templates", __dir__)

  TEMPLATE_PATH = "lib/generators/media_source/templates/media_source.rb.erb"
  TEST_TEMPLATE_PATH = "lib/generators/media_source/templates/media_source_test.rb.erb"

  def copy_media_source_files
    create_file "app/media_sources/#{file_name}_media_source.rb",
                generate_template(TEMPLATE_PATH)
    create_file "test/media_sources/#{file_name}_media_source_test.rb",
                generate_template(TEST_TEMPLATE_PATH)
  end

private

  def generate_template(template_path)
    file_contents = nil
    File.open(template_path) { |f| file_contents = f.read }

    @source_name = file_name
    @source_name_lower = file_name.downcase
    ERB.new(file_contents).result(binding)
  end
end
