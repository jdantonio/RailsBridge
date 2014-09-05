HEROKU_APP = 'frozen-dusk-5904'
RAILS_APP = 'suggestotron'
GIT_ROOT = File.expand_path('../../../..', __FILE__)

namespace :heroku do

  desc "Deploy #{RAILS_APP} to #{HEROKU_APP} on Heroku"
  task :deploy do
    sh "cd #{GIT_ROOT} && git subtree push --prefix #{RAILS_APP} heroku master"
  end

  desc "Migrate database on Heroku #{HEROKU_APP}"
  task :migrate do
    #NOTE: Running this from w/i rake has bundler issues
    #  instead, pipe it through sh
    puts "heroku run --app #{HEROKU_APP} rake db:migrate"
  end

  desc "Open #{RAILS_APP} on Heroku #{HEROKU_APP}"
  task :open do
    #NOTE: Running this from w/i rake has bundler issues
    #  instead, pipe it through sh
    puts "heroku open --app #{HEROKU_APP}"
  end

  desc "View logs for #{RAILS_APP} on Heroku #{HEROKU_APP}"
  task :logs do
    #NOTE: Running this from w/i rake has bundler issues
    #  instead, pipe it through sh
    puts "heroku logs --app #{HEROKU_APP}"
  end

  #desc "Reset the database for #{RAILS_APP} on Heroku #{HEROKU_APP}"
  #task :reset do
    ##NOTE: Running this from w/i rake has bundler issues
    ##  instead, pipe it through sh
    #puts "heroku pg:reset DATABASE_URL --app #{HEROKU_APP}"
  #end
end
