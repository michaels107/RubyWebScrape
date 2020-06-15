
# Created 6/14/2020 by Sean Michaels
# Asks the user to select which scrape they want to use.
require_relative 'combined_searches'

# Created 6/15/2020 by Sean Michaels
# Method to keep prompting the user to either print or compare jobs in their chosen scrape.
def scraping(jobs)
  check = true
  while check
    puts 'Enter \'1\' if you want to print out jobs.'
    puts 'Enter \'2\' if you want to compare jobs.'
    puts 'Enter \'q\' if you want to quit.'
    print 'Enter choice: '
    choice = gets.chomp
    if choice.eql? 'q'
      check = false
    elsif choice.eql? '1'
      jobs.print_listings
    elsif choice.eql? '2'
      jobs.compare_listings
    end
  end
end

# Created 6/15/2020 by Sean Michaels
# Main
puts 'Starting the OSU job posting scrape...'
puts 'If you want to scrape the Student Job Board, enter \'1\'.'
puts 'If you instead want to scrape the OSU Employment Job Board enter \'2\'.'
puts 'If you do not want to scrape either, press enter without a value.'
print 'Enter value: '
input = gets.chomp

# block to figure out which choice is made
if input == '1'
  scraping(CombinedSearches.new false)
elsif input == '2'
  scraping(CombinedSearches.new true)
end
puts 'Quitting...'

