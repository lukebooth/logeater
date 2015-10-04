# Logeater

Parses log files and imports them into a database or converts them to json

### Features

 - Can read from plain text or gzipped log files
 - [Parses parameters safely](https://github.com/concordia-publishing-house/logeater/blob/master/lib/logeater/params_parser.rb)
 - Can import a batch of files at once
 - Parses [these attributes](https://github.com/concordia-publishing-house/logeater/blob/master/db/schema.rb#L19-L32) of requests


### Usage


###### Importing log files

    gem install logeater
    DATABASE_URL=<production database url> logeater import <app name> <path to logs>/*.gz

###### Converting log files to JSON

    gem install logeater
    logeater parse <app name> <path to logs>/*.gz > parsed-logs.json



### Contributing

1. Fork it ( https://github.com/[my-github-username]/logeater/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
