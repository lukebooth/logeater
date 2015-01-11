# Logeater

Parses log files and imports them into a database

### Features

 - Can read from plain text or gzipped log files
 - [Parses parameters safely](https://github.com/concordia-publishing-house/logeater/blob/master/lib/logeater/params_parser.rb)
 - Can import a batch of files at once
 - Parses [these attributes](https://github.com/concordia-publishing-house/logeater/blob/master/db/schema.rb#L19-L32) of requests


### Usage

Clone the gem

    git clone git@github.com:concordia-publishing-house/logeater.git
    bundle

Create the development database

    bundle exec rake db:create db:migrate

Install the gem

    bundle exec rake install

Import log files

    logeater my_app ~/Desktop/logs/*.gz


### To Do

 - Set up databases without cloning the gem?
 - Import to a [Heroku Postgres database](https://dashboard.heroku.com/apps/logs-production)?
 - Parse other kinds of logs?
 - Collect other data from Rails logs?


### Contributing

1. Fork it ( https://github.com/[my-github-username]/logeater/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
