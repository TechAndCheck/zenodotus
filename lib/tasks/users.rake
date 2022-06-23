namespace :users do
  desc "deduplicate facebook users"
  task dedup_facebook: :environment do |t, args|
    progressbar = ProgressBar.create(title: "Loading Sample Data", total: Sources::FacebookUser.count)
    users_to_delete = []

    Sources::FacebookUser.all.each do |user|
      # Find all other users with the same facebook id
      other_users = Sources::FacebookUser.where(facebook_id: user.facebook_id)
      # run through those and add all the posts to this user
      other_users.each do |other_user|
        next if other_user == user  # Don't compare self to self
        other_user.facebook_posts.each do |post|
          post.update!({ author_id: user.id })
        end
        users_to_delete << other_user
      end

      progressbar.increment
    end

    puts "Deleting #{users_to_delete.count} users"
    users_to_delete.each { |user| user.delete }
  end
end
