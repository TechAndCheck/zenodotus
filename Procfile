release: rails db:migrate
web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -e production -C config/sidekiq.yml -t 10 -v
worker: bundle exec sidekiq -e production -q scrapes,2
