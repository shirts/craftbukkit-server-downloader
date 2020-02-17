require 'nokogiri'
require 'httparty'

class GetbukkitScraper
  attr_reader :version

  include HTTParty
  base_uri 'https://getbukkit.org/download' # same version across types

  def version
    @html ||= html
    @version ||= parse_version(@html)
  end

  def html
    @html ||= Nokogiri::HTML(self.class.get('/craftbukkit'))
    @html
  end

  def download_url
    html = HTTParty.get(download_page_url)
    parse_download_url(Nokogiri::HTML(html))
  end

  private

  def download_page_url
    @download_page_url ||= html.css('#downloadr').first.values[0]
  end

  def parse_version(doc)
    content = doc.at('meta[name="keywords"]')['content']
    content.match(/([0-9]{1}+)\.([0-9]{1,2}+)\.([0-9]{0,2})/).to_a.first
  end

  def parse_download_url(doc)
    doc.css('#get-download').css('a').first.values[0]
  end
end
