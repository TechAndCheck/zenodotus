release: rails db:migrate
web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -e production -C config/sidekiq.yml -t 10 -v
web_site_scraper: bundle exec sidekiq -e production -C config/sidekiq_web_scrapes.yml -t 10 -v
