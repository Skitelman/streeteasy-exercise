require_relative "../lib/scraper.rb"
require "pry"
require "json"

class Listing
  @@all = []
  attr_accessor :listing_class, :address, :unit, :url, :price

  def initialize(**listing_params)
    @listing_class = listing_params[:listing_class]
    @address = listing_params[:address]
    @unit = listing_params[:unit]
    @url = listing_params[:url]
    @price = listing_params[:price]
  end

  def parse_price(raw_price)
    self.price = raw_price.gsub("$", "").gsub(",","").to_i
  end

  def parse_address(raw_address)
    address_words = raw_address.split(" ")
    if address_words.last.include?("#") || address_words.last.downcase.include?("floor")
      self.address = address_words[0...-1].join(" ")
      self.unit = address_words[-1].gsub("#","")
    else
      self.address = raw_address.strip
    end
  end

  def parse_url(raw_url)
    base_url = raw_url.split("?").first
    self.url = "https://www.streeteasy.com#{base_url}"
  end

  def attributes
    {
      'listing_class': self.listing_class,
      'address': self.address,
      'unit': self.unit,
      'url': self.url,
      'price': self.price
    }
  end

  def save
    unless @@all.find{|listing| listing.address == self.address && listing.unit == self.unit && listing.listing_class == self.listing_class }
      @@all << self
    end
  end

  def self.all
    @@all
  end

  def self.sales
    @@all.select{|listing| listing.listing_class == "Sale"}
  end

  def self.rentals
    @@all.select{|listing| listing.listing_class == "Rental"}
  end

  def self.most_expensive_sales
    self.sales.sort_by{|listing|
      listing.price
    }.reverse[0...20]
  end

  def self.most_expensive_rentals
    self.rentals.sort_by{|listing|
      listing.price
    }.reverse[0...20]
  end

  def self.most_expensive_sales_attributes
    self.most_expensive_sales.map{|listing|
      listing.attributes
    }
  end

  def self.most_expensive_rentals_attributes
    self.most_expensive_rentals.map{|listing|
      listing.attributes
    }
  end

end
