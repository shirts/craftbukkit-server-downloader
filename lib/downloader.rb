require_relative 'getbukkit_scraper'
require 'httparty'
require 'fileutils'

class Downloader
  attr_reader :scraper, :download_directory

  def initialize(scraper)
    @scraper = scraper
    @version = scraper.version
    @download_directory = TMP_DIR.call(@version)
  end

  TMP_DIR = ->(version) { "/tmp/minecraft/#{version}/spigot/" }

  def download
    directory = TMP_DIR.call(@version)
    filename = "craftbukkit_server.jar"
    FileUtils.mkdir_p(directory)

    puts "downloading to #{directory}"
    File.open("#{directory}/#{filename}", "w") do |file|
      file.binmode
      HTTParty.get(scraper.download_url, stream_body: true) do |fragment|
        file.write(fragment)
      end
    end

    puts "Downloaded #{directory}/#{filename}"
    true
  end
end
