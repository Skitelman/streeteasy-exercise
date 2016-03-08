require_relative "../lib/scraper.rb"
require_relative "../lib/listing.rb"
require 'nokogiri'

class Runner

  def run
    page1_sales_scraper = Scraper.new("http://streeteasy.com/for-sale/soho?page=1&sort_by=price_desc")
    page1_sales_scraper.get_addresses
    page2_sales_scraper = Scraper.new("http://streeteasy.com/for-sale/soho?page=2&sort_by=price_desc")
    page2_sales_scraper.get_addresses
    page1_rental_scraper = Scraper.new("http://streeteasy.com/for-rent/soho?page=1&sort_by=price_desc")
    page1_rental_scraper.get_addresses
    page2_rental_scraper = Scraper.new("http://streeteasy.com/for-rent/soho?page=2&sort_by=price_desc")
    page2_rental_scraper.get_addresses
    File.write('sales.json', Listing.most_expensive_sales_attributes.to_json)
    File.write('rentals.json', Listing.most_expensive_rentals_attributes.to_json)
    puts "Great Success!"
  end

end
