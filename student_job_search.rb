# frozen_string_literal: true
# Created 6/09/2020 by Duytan Tran
# Edited 6/11/2020 by Sean Michaels
# Edited 6/12/2020 by Sean Michaels
# Edited 6/13/2020 by Duytan Tran
# Edited 6/14/2020 by Duytan Tran
# Scrapes the OSU student job board search at https://sfa.osu.edu/jobs/job-board
# for available listings, outputting them to the console in a quick summarized manner with
# links to each specific listing for additional details.
require 'mechanize'

# Created 6/12/2020 by Sean Michaels
# Edited 6/13/2020 by Duytan Tran: Improved readability of I/O
# Method that gets what the user whats to filter their results by
def filter
  print 'Enter keywords(if no keyword press enter): '
  data = []
  data.push gets.chomp
  print 'Would you like to filter by Off Campus[Y/N]: '
  if gets.chomp.eql? 'Y'
    data.push true
  else
    data.push false
  end
  print 'Would you like to filter by On Campus[Y/N]: '
  if gets.chomp.eql? 'Y'
    data.push true
  else
    data.push false
  end
  print 'Would you like to filter by Work from Home[Y/N]: '
  if gets.chomp.eql? 'Y'
    data.push true
  else
    data.push false
  end
  data
end

# Created 6/14/2020 by Duytan Tran
# Retrieves specific job site information, shortens it if it is too long
def get_specific_listing_info a, info
  parsed_listing = Nokogiri::HTML(a.get(info[:link]).body)
  additional_info = parsed_listing.css('dl').text.split("\n")
  additional_info.each_with_index do |element, i|
    # Searches for pay, duration, and hours within each job page, filtering accordingly
    if /Pay/.match?(element)
      info[:pay] = additional_info[i + 2].strip
      info[:pay] = 'N/A' if info[:pay].nil? || info[:pay].empty?
      info[:pay] = info[:pay].slice(0...67) + '...' if info[:pay].length > 70
    elsif /Job Duration/.match?(element)
      info[:duration] = additional_info[i + 2].strip
      info[:duration] = 'N/A' if info[:duration].nil? || info[:duration].empty?
      info[:duration] = info[:duration].slice(0...67) + '...' if info[:duration].length > 70
    elsif /Hours/.match?(element)
      info[:hours] = additional_info[i + 2].strip
      info[:hours] = 'N/A' if  info[:hours].nil? || info[:hours].empty?
      info[:hours] = info[:hours].slice(0...67) + '...' if info[:hours].length > 70
    end
  end
end

# Created 6/09/2020 by Duytan Tran
# Edited 6/11/2020 by Sean Michaels: Created it so that it will search for keywords
# Edited 6/12/2020 by Sean Michaels: Added method to ask user for data for their search
# Edited 6/13/2020 by Duytan Tran: Added additional scraping for pay, duration, and hours
# Scrapes Student Job listings and returns them in an array of hashes
def get_student_job_listings
  # Processing user filter choices
  url = 'https://sfa.osu.edu/jobs/job-board'
  puts 'Scraping ' + url + '...'
  a = Mechanize.new { |agent| agent.user_agent_alias = 'Windows Firefox' }
  search_page = a.get(url)
  search_form = search_page.forms.last
  data = filter
  i = 1
  search_form.search = data[0]
  search_form.checkboxes.map do |box|
    box.click if data[i].eql? true
    i += 1
  end
  unparsed_job_list = a.submit(search_form, search_form.buttons.first)
  parsed_job_list = Nokogiri::HTML(unparsed_job_list.body)

  # Filling out array of hash listings with individualized job info
  puts 'This may take a while...'
  jobs = []
  parsed_job_list.css('ol li').each do |job|
    # Summary information insertion
    info = { title: job.css('h4')[0].text,
             employer: job.css('h4')[1].text,
             desc: job.css('p')[0].text,
             link: 'https://sfa.osu.edu/jobs/' + job.css('a')[0]['href'] }
    get_specific_listing_info a, info
    jobs << info
  end
  jobs
end

# Created 6/09/2020 by Duytan Tran
# Prints job listings stored in an array of hashes
def print_student_job_listings jobs
  puts "Available student jobs: #{jobs.count}"
  jobs.each_with_index do |info, i|
    puts "Job listing #{i + 1}"
    puts 'Title: ' + info[:title]
    puts 'Employer: ' + info[:employer]
    puts 'Pay: ' + info[:pay]
    puts 'Job Duration: ' + info[:duration]
    puts 'Hours: ' + info[:hours]
    puts 'Description: ' + info[:desc]
    puts 'Additional information: ' + info[:link] + "\n\n"
  end
end
