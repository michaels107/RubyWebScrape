# frozen_string_literal: true

# Created 6/11/2020 by Reema Gupta
# Edited 6/11/2020 by Caroline Wheeler
# Edited 6/13/2020 by Duytan Tran
# Edited 6/13/2020 by Reema Gupta
# Edited 6/15/2020 by Caroline Wheeler
# Edited 6/15/2020 by Sean Michaels
# Edited 6/17/2020 by Caroline Wheeler
# Edited 6/17/2020 by Reema Gupta
# Edited 6/17/2020 by Sean Michaels
# Edited 6/18/2020 by Duytan Tran
# Scrapes all pages of  the  job board search at https://www.jobsatosu.com/postings/search
require 'mechanize'

# Created 6/11/2020 by Caroline Wheeler
# Gathers search criteria from user for location
# Returns "1" if user only wants to look in Columbus and "any" otherwise
def location
  print 'Would you like to search only in Columbus? [Y/N]: '
  x = gets.chomp
  x.eql?('Y') ? '1' : 'any'
end

# Created 6/11/2020 by Caroline Wheeler
# Gathers search criteria from user for data posted
def posted_within
  puts 'Posted within: any time period [hit enter], the last day [1], the last week [2], the last month [3].'
  x = gets.chomp # x temporarily holds the number entered by user
  if x.eql?('1')
    'day'
  elsif x.eql?('2')
    'week'
  elsif x.eql?('3')
    'month'
  else
    ''
  end
end

# Created 6/11/2020 by Caroline Wheeler
# Gets and returns keywords from user
def keywords
  print 'Enter keywords or select enter to skip to next search criteria: '
  gets.chomp
end

# Created 6/11/2020 by Caroline Wheeler
# Allows user to fill our search criteria for osu job search
# Returns the search form with/without search criteria filled out.
def osu_form
  data = []
  # get keywords
  data.push(keywords)
  # gets range of posting
  data.push(posted_within)
  # gets location
  data.push(location)
  data
end

# Created 6/11/2020 by Reema Gupta
# Edited  6/12/2020 by Reema Gupta: Added methods for getting and printing the job list
# Edited  6/13/2020 by Reema Gupta: Changed forms.last to forms.fast and edited css parts
# Edited  6/13/2020 by Duytran Tran: Added.strip! to info values, shortened layering into a variable
# Edited  6/13/2020 by Reema Gupta: Included code so as to run the loop for all pages on the website
# Edited  6/13/2020 by Duytan Tran: Removed calls to get_job_listings and print_job_listings
# Edited  6/15/2020 by Caroline Wheeler: Added call to osu_form and code necessary to implement search criteria
# Edited  6/15/2020 by Caroline Wheeler: Added single line comments
# Edited  6/16/2020 by Reema Gupta: changed the pagination_url so as to include search criteria
# Edited  6/17/2020 by Reema Gupta: changed .round to.ceil in last page so as to always round up
# Edited  6/17/2020 by Reema Gupta: included a variable to store user input for search criteria
# Edited  6/17/2020 by Reema Gupta: Added another pagination url for condition when search criteria is not required
# Edited  6/17/2020 by Reema Gupta: removed parameter from osu form
# Edited  6/17/2020 by Sean Michaels: Debugged and fixed the url so it correctly filters
# Edited  6/17/2020 by Reema Gupta: Added the condition to exit program when there are 0 listings
# Scrapes all pages of  the  job board search at https://www.jobsatosu.com/postings/search
# for available listings, outputting them to the console in a quick summarized manner with
# links to each specific listing for view details.
def get_job_listings
  url = 'https://www.jobsatosu.com/postings/search'
  puts 'Scrap ' + url + '...'
  a = Mechanize.new { |agent| agent.user_agent_alias = 'Windows Firefox' } # creates an object to send request
  search_page = a.get(url) # issue a request
  search_form = search_page.forms.first # find form
  # this section authored by Caroline Wheeler
  print 'Would you like to enter search criteria? [Y/N]: '
  criteria = gets.chomp
  if criteria.eql?('Y')
    data = osu_form # call to osu_form will return an array containing search criteria
    search_form.query = data[0] # enters keywords
    search_form.query_v0_posted_at_date = data[1] # enters preferred date of posting
    search_form.field_with(:name => '591[]').option(:value => data[2]).click # enters location preference
  end
  unparsed_job_list = a.submit(search_form, search_form.button_with(:value => 'Search')) # search button is clicked
  # end section by Caroline Wheeler
  parsed_job_list = Nokogiri::HTML(unparsed_job_list.body)
  # Creating an array of hash listings with individualized job info
  jobs = []
  page = 1
  job_list = parsed_job_list.css('div.job-item.job-item-posting') # css class name for each listing
  per_page = job_list.count
  total = parsed_job_list.css('span.smaller.muted').text.split('(')[1].split(')')[0].to_i # get the total listings
  if total.zero? # ends program when there are 0 listing
    puts '0 listings'
    sleep 3
    puts 'Quitting'
    sleep 3
    exit
  else
    last_page = (total.to_f / per_page.to_f).ceil # used to get the total number of pages on the site
  end
  while page <= last_page
    if criteria.eql? 'Y'
      # when search criteria is selected
      pagination_url = "https://www.jobsatosu.com/postings/search?utf8=✓
&query=#{data[0]}&query_v0_posted_at_date=#{data[1]}&591=#{data[2]}&577=&578=&579=&commit=Search&page=#{page}"
    else
      # when search criteria is not selected
      pagination_url="https://www.jobsatosu.com/postings/search?commit=Search&page=#{page}"
    end

    pagination_search_page = a.get(pagination_url)
    pagination_parsed_job_list = Nokogiri::HTML(pagination_search_page.body)
    pagination_job_list = pagination_parsed_job_list.css('div.job-item.job-item-posting')
    pagination_job_list.css('div.job-item.job-item-posting').each do |job|
      # Filling out array listings with individualized job info
      job_layering = 'div.col-md-8.col-xs-12 div.col-md-2.col-xs-12.job-title.job-title-text-wrap.col-md-push-0'
      # Summary information insertion
      info = {
        title: job.css('h3').text.strip!,
        work_title: job.css(job_layering)[0].text.strip!,
        dept: job.css(job_layering)[1].text.strip!,
        app_deadline: job.css(job_layering)[2].text.strip!,
        open_number: job.css(job_layering)[3].text.strip!,
        target_salary: job.css(job_layering)[4].text.strip!,
        desc: job.css('span.job-description').text.strip!,
        details: 'https://www.jobsatosu.com' + job.css('a')[0]['href']
      }
      jobs << info
    end
    page += 1 # moves to next page when listings of current page are included
  end
  jobs
end

# Created 6/12/2020 by Reema Gupta
# Edited  6/13/2020 by Reema Gupta: Added code for printing the job listing
# Edited 6/13/2020 by Duytan Tran: Added \n\n, allow additional spacing between listings
# Prints job listings and their details which are stored in an array of hashes
def print_job_listings jobs
  puts "Available jobs: #{jobs.count}"
  jobs.each_with_index do |info, i|
    puts "Job listing #{i + 1}"
    puts 'Title:' + info[:title]
    puts 'Work Title:' + info[:work_title]
    puts 'Department:' + info[:dept]
    puts 'Application Deadline:' + info[:app_deadline]
    puts 'opening number:' + info[:open_number]
    puts 'Salary:' + info[:target_salary]
    puts 'Description:' + info[:desc]
    puts 'View Details:' + info[:details] + "\n\n"
  end
end

# Created by 6/15/2020 by Sean Michaels
# Edited 6/17/2020 by Caroline Wheeler - change 'w+'' to 'a+'' so appends to file
# Edited 6/18/2020 by Duytan Tran: Changed file pathing to support saved_data folder
# Method to print to a file you created
def print_file_job jobs, file_name
  File.open(File.join(Dir.pwd, "saved_data/#{file_name}"), 'a+') do |f|
    jobs.each_with_index do |job, i|
    f.write"Job listing #{i + 1}\n"
    f.write"Title: #{job[:title]}\n"
    f.write"Work Title: #{job[:work_title]}\n"
    f.write"Department: #{job[:dept]}\n"
    f.write"Application Deadline: #{job[:app_deadline]}\n"
    f.write"Opening number: #{job[:open_number]}\n"
    f.write"Salary: #{job[:target_salary]}\n"
    f.write"Description: #{job[:desc]}\n"
    f.write"View Details: #{job[:details]}\n\n"
    end
  end
end
