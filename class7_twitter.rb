=begin
I appoligize in advanced for the many steps to get this program installed.  
But once it is installed, you can do amazing things!

online documentation to help with scrapping
http://nokogiri.org/
http://ruby.bastardsbook.com/chapters/html-parsing/

first you have to install nokogiri (see http://nokogiri.org/tutorials/installing_nokogiri.html for details):

windows
 - go to http://rubyinstaller.org/downloads/, look for 'DEVELOPMENT KIT' on the left and select the right file, most likely the first one
 - after download is complete, double click on file and select to extract to: C:\DevKit
 - open the command prompt (Start button > type in cmd in search bar)
 - run the following commands:
cd c:\DevKit
ruby dk.rb init
ruby dk.rb install
gem install nokogiri

mac (easy way)
 - open terminal and type the following:
brew install libxml2 libxslt libiconv
brew link libxml2 libxslt libiconv
gem install nokogiri

mac (hard way if easy way does not work)
 - open terminal and type the following:
cd ~/Downloads
ARCHFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future brew install libxml2 libxslt
brew link libxml2 libxslt
brew install wget
wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz
tar xvfz libiconv-1.13.1.tar.gz
cd libiconv-1.13.1
./configure --prefix=/usr/local/Cellar/libiconv/1.13.1
make
sudo make install
sudo gem install nokogiri -- --with-xml2-include=/usr/local/Cellar/libxml2/2.7.8/include/libxml2 --with-xml2-lib=/usr/local/Cellar/libxml2/2.7.8/lib --with-xslt-dir=/usr/local/Cellar/libxslt/1.1.26 --with-iconv-include=/usr/local/Cellar/libiconv/1.13.1/include --with-iconv-lib=/usr/local/Cellar/libiconv/1.13.1/lib

linux
sudo apt-get install ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8
sudo apt-get install libreadline-ruby1.8 libruby1.8 libopenssl-ruby
sudo apt-get install libxslt-dev libxml2-dev
sudo gem install nokogiri

=end


# the twitter url you want to scrape
url = 'https://twitter.com/jsgeorgia'
puts "the url we are scrapping is: #{url}"



###########################
## You can ignore the steps
## starting here until the 
## next big block of comments
## - this code pulls in twitter
##   feed and creates list 
##   of its data
###########################


# have to require these gems to be able to get content from urls
require 'rubygems'
require 'nokogiri'
require 'open-uri'

# pull in the twitter page
doc = Nokogiri::HTML(open(url))

# write out the page title
puts "the page title of this url is: #{doc.at_css("title").content.strip}"

# get the username for this page
username = doc.at_css('.profile-card-inner h2.username').content.strip
puts "the username for this page is: #{username}"

# get all of the tweets
doc_tweets = doc.css('#timeline ol#stream-items-id li .tweet')
puts "there are #{doc_tweets.length} tweets on this page"

# for each tweet, lets pull out the following and save into a list.
# 0 - date
# 1 - status
# 2 - name
# 3 - username
# 4 - is this a retweet?
# 5 - link
# this list will then be added to the variable list tweets
tweets = []
doc_tweets.each do |tweet|
  tweet_item = []
  # get the time of the tweet
  time = tweet.at_css(".content .time span")['data-time']
  # convert time in # of seconds to a time object
  tweet_item[0] = time.nil? ? nil : Time.at(time.to_i)

  # get the status
  tweet_item[1] = tweet.at_css(".content p.tweet-text").content.strip
  
  # get the name of person posting tweet
  tweet_item[2] = tweet.at_css(".content .account-group .fullname").content.strip

  # get the username of person posting tweet
  tweet_item[3] = tweet.at_css(".content .account-group .username").content.strip

  # is this a re-tweet?
  tweet_item[4] = !tweet.at_css(".context .js-retweet-text").nil?

  # link to tweet
  tweet_item[5] = "https://twitter.com/" + tweet.at_css(".content .time a")['href']

  # add this tweet item to the list of all tweets
  tweets << tweet_item
end
puts "we pulled out and processed #{tweets.length} tweets"


###########################
## Data now exists in 'tweets' 
## list variable.
## Have fun and play!
###########################


# see how many usernames match the username of this page
username_count = tweets.select{|x| x[3] == username}.length
puts "out of #{tweets.length}, #{username_count} were written by #{username}"





