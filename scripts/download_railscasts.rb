#!/usr/local/bin/ruby

# A script to download the latest episodes from railscasts.com
#
# requires  simple-rss (1.2.2) gem
# and base on linux wget
#
# author: modsaid   < mahmoud@modsaid.com >
#

require 'rubygems'
require 'simple-rss'
require 'open-uri'

RAILS_CASTS_FEED='http://feeds.feedburner.com/railscasts'
DOWNLOAD_DIRECTORY='.'

# parse the current directory and get the downloaded eposodes ids
downloaded_episodes_ids=[]
begin
  downloaded_episodes_ids = Dir.new(DOWNLOAD_DIRECTORY).entries.select{|f| f =~ /^(\d){3}.*.mov/ }.collect{|f| f.split('_').first.to_i}
rescue
end

def get_id(rss_item)
  rss_item.link.split('/').last.split('-').first.to_i
end

puts "Checking railscasts feeds for new episodes..."

rss = SimpleRSS.parse open(RAILS_CASTS_FEED)
count=0

rss.items.each do |rss_item|
  id = get_id(rss_item)
  unless downloaded_episodes_ids.include?(id)
    puts "Downloading #{rss_item.title}.."
    link = `wget http://railscasts.com/episodes/#{id} -O- | grep -oi 'http://media.railscasts.com/videos/[a-z_0-9]*.mov'`
    `wget -c #{link.strip}`
    count +=1
  end
end

puts "Done.  #{count} new episodes were downloaded"


