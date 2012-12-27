require 'tire'
require 'barton/model'

module Barton
  class << self
    
    def setup(env=nil)
      # => set environment
      Barton.base_url = 'http://localhost:9292' if env == :test
      source = env == :test ? 'spec/data' : 'data'
      Tire.index ENV['ES_INDEX'] { delete }
      puts "Setting up #{env} environment with #{ENV['ES_INDEX']} index"
      
      # => purge and load data from YAML source
      Dir["#{source}/*.yaml"].each do |filename|
        data = YAML::load_file filename if File.exist? filename
        data.each do |d|
          doc = Barton::Model::Electorate.new d
          doc.save
        end
      end
    end
    
    def electorates(args={})
      return nil if args.empty?
      Barton::Model::Electorate.find args[:id] if args.key? :id
    end
    
    def base_url
      @@api_url ||= 'http://barton.experimentsindemocracy.org'
    end

    def base_url=(url)
      @@api_url = url
    end
  end
end