require_relative "../lib/listing.rb"
require 'open-uri'
require 'nokogiri'
require 'pry'
require "json"

class Scraper
  attr_reader :page

  def initialize(url)
    @page = Nokogiri::HTML(open(url))
  end

  def get_addresses
    self.page.css("div.item div.details-title a").each_with_index do |details, index|
      if index.even?
        listing = Listing.new
        listing.parse_url(details["href"])
        listing.listing_class = details["data-gtm-listing-type"].capitalize
        listing.parse_address(details.children.text)
        listing.parse_price(details.parent.parent.css("div.price-info span.price").text)
        listing.save
      end
    end
  end

end

# page1_sales_scraper = Scraper.new("http://streeteasy.com/for-sale/soho?page=1&sort_by=price_desc")
# page1_sales_scraper.get_addresses
# page2_sales_scraper = Scraper.new("http://streeteasy.com/for-sale/soho?page=2&sort_by=price_desc")
# page2_sales_scraper.get_addresses
# page1_rental_scraper = Scraper.new("http://streeteasy.com/for-rent/soho?page=1&sort_by=price_desc")
# page1_rental_scraper.get_addresses
# page2_rental_scraper = Scraper.new("http://streeteasy.com/for-rent/soho?page=2&sort_by=price_desc")
# page2_rental_scraper.get_addresses
# File.write('sales.json', Listing.most_expensive_sales_attributes.to_json)
# File.write('rentals.json', Listing.most_expensive_rentals_attributes.to_json)
