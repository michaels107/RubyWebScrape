# Created 6/14/2020 by Sean Michaels
# Edited 6/15/2020 by Sean Michaels
# Edited 6/16/2020 by Reema Gupta
# Edited 6/16/2020 by Caroline Wheeler
# Edited 6/18/2020 by Duytan Tran
# Asks the user to select which scrape they want to use.
require_relative 'class/combined_searches'

# Created 6/15/2020 by Sean Michaels
# Edited 6/16/2020  by Reema Gupta: Included the code to send the job text file to an email
# Edited 6/16/2020 by Caroline Wheeler: added calls to pick_favorites
# Edited 6/18/2020 by Duytan Tran: Changed file pathing of favorites
# Method to keep prompting the user to either print or compare jobs in their chosen scrape.
def scraping jobs
  check = true
  while check
    puts 'Enter \'1\' if you want to print out jobs.'
    puts 'Enter \'2\' if you want to compare jobs.'
    puts 'Enter \'3\' if you want to print jobs to a file.'
    puts 'Enter \'4\' if you want to pick your favorites.'
    puts 'Enter \'5\' if you want to print your favorites'
    puts 'Enter \'q\' if you want to quit.'
    print 'Enter choice: '
    choice = gets.chomp
    puts ''
    if choice.eql? 'q'
      check = false
    elsif choice.eql? '1'
      jobs.print_listings
    elsif choice.eql? '2'
      jobs.compare_listings
    elsif choice.eql?'3'
      print 'Enter file name with .txt extension to create your file: '
      file_name = $stdin.gets.chomp
      jobs.print_to_file file_name
      print 'Do you want the file to be emailed to you? (Y/N): '
      s = gets.chomp
      if s.eql? 'Y'
        print 'Enter a valid email id where you want the text file to be emailed: '
        id = gets.chomp
        jobs.email id, file_name
      end
    elsif choice.eql?'4'
      jobs.pick_favorites
    elsif choice.eql?'5'
      f = File.open(File.join(Dir.pwd, 'saved_data/favorites'))
      puts f.read
      f.close
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

