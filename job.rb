require 'mechanize'
# Created 6/11/2020 by Reema Gupta
# Edited  6/12/2020 by Reema Gupta
# Edited  6/13/2020 by Reema Gupta
=begin
Scrapes the  job board search at https://www.jobsatosu.com/postings/search
 for available listings, outputting them to the console in a quick summarized manner with
links to each specific listing for view details.
=end
def get_job_listings
  url='https://www.jobsatosu.com/postings/search'
  puts 'Scrap '+ url + '...'
  a = Mechanize.new { |agent| agent.user_agent_alias = 'Windows Firefox' }
  search_page = a.get(url)
  search_form = search_page.forms.first
  unparsed_job_list = a.submit(search_form, search_form.buttons.first)
  parsed_job_list = Nokogiri::HTML(unparsed_job_list.body)
  jobs = []
  parsed_job_list.css('div.job-item.job-item-posting').each do |job|
    info = { title: job.css('h3').text,
             work_title: job.css(' div.col-md-8.col-xs-12 div.col-md-2.col-xs-12.job-title.job-title-text-wrap.col-md-push-0')[0].text ,
             dept: job.css('div.col-md-8.col-xs-12 div.col-md-2.col-xs-12.job-title.job-title-text-wrap.col-md-push-0')[1].text,
             app_deadline: job.css('div.col-md-8.col-xs-12 div.col-md-2.col-xs-12.job-title.job-title-text-wrap.col-md-push-0')[2].text,
             open_number: job.css(' div.col-md-8.col-xs-12 div.col-md-2.col-xs-12.job-title.job-title-text-wrap.col-md-push-0')[3].text,
             target_salary: job.css('div.col-md-8.col-xs-12 div.col-md-2.col-xs-12.job-title.job-title-text-wrap.col-md-push-0')[4].text,
             desc: job.css('span.job-description').text,
             details: 'https://www.jobsatosu.com' + job.css('a')[0]['href']
            }
    jobs << info
  end
  jobs
end

# Created 6/12/2020 by Reema Gupta
# Edited  6/13/2020 by Reema Gupta
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
    puts 'Description:' +info[:desc]
    puts 'View Details:' +info[:details]
    end
end

job_listings = get_job_listings
print_job_listings job_listings