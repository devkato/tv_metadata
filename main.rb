require 'open-uri'
require 'uri'
require 'fileutils'
require 'yajl'
require 'yaml'
require 'json'
require 'logger'

class TvMetadataCrawler

  def initialize
    @config = Yajl::Parser.parse(YAML.load_file("./config.yml").to_json, symbolize_keys: true)
    @api_base = 'http://tvstream.izunak.com/api/stream'
    @logger = Logger.new(STDOUT)

    @logger.debug "api_base: #{@api_base}"
  end

  def crawl

    now = Time.now
    dir_path = "./dest/#{now.strftime('%Y%m%d')}/#{now.strftime('%H')}"

    FileUtils.mkdir_p(dir_path) unless File.exists?(dir_path)

    @config[:stations].each do |channel, station_id|

      @logger.debug "crawl: channel => #{channel}, station_id => #{station_id}"

      params = {
        station_id: station_id
      }

      url = "#{@api_base}?" + URI.encode_www_form(params)

      @logger.debug "url: #{url}"


      open("#{dir_path}/#{channel}.json", 'w').write open(url).read

      sleep 1
    end
  end
end

TvMetadataCrawler.new.crawl
