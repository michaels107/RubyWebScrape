# frozen_string_literal: true

# Created 6/14/2020 by Duytan Tran
require_relative 'student_job_search'
require_relative 'job'
require 'mail'

# Store the results of two OSU job scrapings under a single umbrella where various functions may be performed
class CombinedSearches
  # Created 6/14/2020 by Duytan Tran
  # Produces the job_listings depending on whether it is OSU employment search or student job search
  def initialize osu_employment
    @osu_employment = osu_employment
    @job_listings = if @osu_employment
                      get_job_listings
                    else
                      get_student_job_listings
                    end
  end

  # Created 6/14/2020 by Duytan Tran
  # Prints the job listings with the appropriate implementation
  def print_listings
    if @osu_employment
      print_job_listings @job_listings
    else
      print_student_job_listings @job_listings
    end

  end

  # Created 6/15/2020 by Sean Michaels
  # Edited 6/16/2020 by Sean Michaels : Removed the check of scrape as the method is overloaded
  # Edited 6/16/2020 by Reema Gupta : Shifted the input statements to scrape.rb
  # Prints the job listings with the appropriate implementation to a file
  def print_to_file  file_name
    print_file @job_listings, file_name
  end

  # Created 6/14/2020 by Duytan Tran
  # Compares two job listings selected by the user
  def compare_listings
    # Show current listing choices
    print_listings
    if @job_listings.count < 2
      puts 'Cannot perform comparisons on job listing counts less than 2!'
      return
    end

    # Getting user choices, allowing the option to abort
    puts 'Please select two listings by number for which you wish to compare! (non-answer to abort)'
    print 'Selection 1: '
    sel_one = gets.chomp.to_i - 1
    print 'Selection 2: '
    sel_two = gets.chomp.to_i - 1
    unless (0...@job_listings.count).cover?(sel_one) && (0...@job_listings.count).cover?(sel_two)
      puts 'Aborting list comparison!'
      return
    end

    # Comparing two listing's relevant information in a side by side format
    listing_one = @job_listings[sel_one]
    listing_two = @job_listings[sel_two]
    print format('%-10<label>s', label: 'Comparing')
    if @osu_employment
      puts format('%70<result>s' + "\tv\t" + listing_two[:details], result: listing_one[:details])
      print format('%-10<label>s', label: 'Title')
      puts format('%70<result>s' + "\t|\t" + listing_two[:title], result: listing_one[:title])
      print format('%-10<label>s', label: 'Work Title')
      puts format('%70<result>s' + "\t|\t" + listing_two[:work_title], result: listing_one[:work_title])
      print format('%-10<label>s', label: 'Dept')
      puts format('%70<result>s' + "\t|\t" + listing_two[:dept], result: listing_one[:dept])
      print format('%-10<label>s', label: 'Deadline')
      puts format('%70<result>s' + "\t|\t" + listing_two[:app_deadline], result: listing_one[:app_deadline])
      print format('%-10<label>s', label: 'Salary')
      puts format('%70<result>s' + "\t|\t" + listing_two[:target_salary], result: listing_one[:target_salary])
    else
      puts format('%70<result>s' + "\tv\t" + listing_two[:link], result: listing_one[:link])
      print format('%-10<label>s', label: 'Title')
      puts format('%70<result>s' + "\t|\t" + listing_two[:title], result: listing_one[:title])
      print format('%-10<label>s', label: 'Employer')
      puts format('%70<result>s' + "\t|\t" + listing_two[:employer], result: listing_one[:employer])
      print format('%-10<label>s', label: 'Pay')
      puts format('%70<result>s' + "\t|\t" + listing_two[:pay], result: listing_one[:pay])
      print format('%-10<label>s', label: 'Duration')
      puts format('%70<result>s' + "\t|\t" + listing_two[:duration], result: listing_one[:duration])
      print format('%-10<label>s', label: 'Hours')
      puts format('%70<result>s' + "\t|\t" + listing_two[:hours], result: listing_one[:hours])
    end
  end

  # Created 06/16/2020 by Reema Gupta
  # Method to send an email with an attached text file
  def email(receiver_id, file_name)
    smtp_server = "smtp.gmail.com"
    email_id = "quaranteamcse3901@gmail.com"
    password = "Quaranteam3901"
    domain = "gmail.com"
    port = 587

    mail = Mail.new do
      from email_id
      to receiver_id
      subject 'Job Search Listings'
      body "Please find the attached text file"
      add_file "#{File.realpath(file_name)}"

    end
    options = {:address => smtp_server,
               :port => port,
               :domain => domain,
               :user_name => email_id,
               :password => password,
               :authentication => 'plain',
               :enable_starttls_auto => true}
    mail.delivery_method :smtp, options
    mail.deliver

  end

  # Created 6/17/2020 by Caroline Wheeler
  # Allows user to select favorite job listings and write them to favorites file
  def pick_favorites
    fav = []
    puts 'You have the option to favorite job listings.'
    puts 'They will be saved and stored separately.'
    print_listings
    puts
    puts 'Enter the numbers of the job listings you would like to favorite (press enter after each num): '
    loop do
        input = gets.chomp
        break if input.empty?

        fav << input
      end
    return if fav.empty?

    print_to_file('favorites')
    end
end