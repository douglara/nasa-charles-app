web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -t 10 -c 1 -e production