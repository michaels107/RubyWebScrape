# frozen_string_literal: true

# Created 6/09/2020 by Duytan Tran
# Edited 6/11/2020 by Sean Michaels
# Edited 6/12/2020 by Sean Michaels
# Scrapes the OSU student job board search at https://sfa.osu.edu/jobs/job-board
# for available listings, outputting them to the console in a quick summarized manner with
# links to each specific listing for additional details.
require 'mechanize'

# Created 6/12/2020 by Sean Michaels
# Method that gets what the user whats to filter their results by
def filter
  print 'Enter keywords(if no keyword press enter): '
  data = []
  data.push gets.chomp
  puts 'Would you like to filter by Off Campus[Y/N]:'
  if gets.chomp.eql? 'Y'
    data.push true
  else
    data.push false
  end
  puts 'Would you like to filter by On Campus[Y/N]:'
  if gets.chomp.eql? 'Y'
    data.push true
  else
    data.push false
  end
  puts 'Would you like to filter by Work from Home[Y/N]:'
  if gets.chomp.eql? 'Y'
    data.push true
  else
    data.push false
  end
  data
end

# Created 6/09/2020 by Duytan Tran
# Edited 6/11/2020 by Sean Michaels : Created it so that it will search for keywords
# Edited 6/12/2020 by Sean Michaels : Added method to ask user for data for their search
# Scrapes Student Job listings and returns them in an array of hashes
def get_student_job_listings
  url = 'https://sfa.osu.edu/jobs/job-board'
  puts 'Scraping ' + url + '...'
  a = Mechanize.new { |agent| agent.user_agent_alias = 'Windows Firefox' }
  search_page = a.get(url)
  search_form = search_page.forms.last
  data = filter
  i = 1
  search_form.search = data[0]
  search_form.checkboxes.map do |box|
    if data[i].eql? true
      box.click
    end
    puts search_form.inspect
    i += 1
  end
  unparsed_job_list = a.submit(search_form, search_form.buttons.first)
  parsed_job_list = Nokogiri::HTML(unparsed_job_list.body)
  jobs = []
  parsed_job_list.css('ol li').each do |job|
    info = { title: job.css('h4')[0].text,
             employer: job.css('h4')[1].text,
             desc: job.css('p')[0].text,
             link: 'https://sfa.osu.edu/jobs/' + job.css('a')[0]['href'] }
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
    puts 'Description: ' + info[:desc]
    puts 'Additional information: ' + info[:link] + "\n\n"
  end
end

job_listings = get_student_job_listings
print_student_job_listings job_listings
