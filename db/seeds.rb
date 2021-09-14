# typed: strict
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create([{
  email: "admin@example.com",
  password: "password123",
  approved: true,
  admin: true,
  confirmed_at: Time.now
},
{
  email: "user@example.com",
  password: "password123",
  approved: false,
  admin: false,
  confirmed_at: Time.now
}])

Sources::Tweet.create_from_url "https://twitter.com/kairyssdal/status/1415029747826905090"
Sources::Tweet.create_from_url "https://twitter.com/leahstokes/status/1414669810739281920"
Sources::Tweet.create_from_url "https://twitter.com/dissectpodcast/status/1409323315735384064"

archive_items = ArchiveItem.all

MediaReview.create(original_media_link: "https://twitter.com/kairyssdal/status/1415029747826905090",
                   media_authenticity_category: "real fake",
                   original_media_context_description: "not too much context",
                   archive_item_id: archive_items[0].id)


MediaReview.create(original_media_link: "https://twitter.com/leahstokes/status/1414669810739281920",
                   media_authenticity_category: "Seems legit",
                   original_media_context_description: "This is an image and that's the context",
                   archive_item_id: archive_items[1].id)

MediaReview.create(original_media_link: "https://twitter.com/dissectpodcast/status/1409323315735384064",
                   media_authenticity_category: "Might be real or fake",
                   original_media_context_description: "Image is warped",
                   archive_item_id: archive_items[2].id)
