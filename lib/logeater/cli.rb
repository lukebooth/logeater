require "thor"
require "logeater"

module Logeater
  class CLI < Thor

    option :force, type: :boolean, desc: "Imports all specified files, overwiting previous imports if necessary"
    desc "import APP FILES", "imports files"
    def import(app, *files)
      unless options[:force]
        imported_files = Logeater::Request.where(app: app).pluck("DISTINCT logfile")
        files.reject! { |file| imported_files.member? File.basename(files[0]) }
      end

      if files.empty?
        $stderr.puts "No files to import"
        return
      end

      started_all = Time.now
      files.each_with_index do |file, i|
        reader = Logeater::Reader.new(app, file, progress: true)
        reader.remove_existing_entries!

        started_count = Logeater::Request.count
        started_at = Time.now
        reader.import
        finished_at = Time.now
        finished_count = Logeater::Request.count

        $stderr.puts " > \e[34mImported \e[1m%d\e[0;34m requests in \e[1m%.2f\e[0;34m seconds (%d of %d)\e[0m\n\n" % [
          finished_count - started_count,
          finished_at - started_at,
          i + 1,
          files.length ]
      end

      finished_all = Time.now
      seconds = finished_all - started_all
      minutes = (seconds / 60).to_i
      seconds -= (minutes * 60)
      $stderr.puts "Total time %d minutes, %.2f seconds" % [minutes, seconds]
    end

  end
end
