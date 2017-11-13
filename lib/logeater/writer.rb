module Logeater
  class Writer
    attr_reader :app, :events, :path

    def initialize(app, events, path)
      @app = app
      @events = events
      @path = path || "./db_logs/#{app}"
    end

    def write!
      File.open(File.expand_path(path), "w") do |file|
        file.write events.pluck(:original).join()
      end
    end

  end
end
