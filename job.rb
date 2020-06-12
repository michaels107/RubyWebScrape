require 'mechanize'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
def get_job_listings
  url='https://www.jobsatosu.com/postings/search'
  puts 'Scrap '+ url + '...'
  agent = Mechanize.new { |a| a.user_agent_alias = 'Windows Firefox' }
  page = agent.get(url)
  search_form = page.forms.last
  unparsed_job_list = agent.submit(search_form, search_form.buttons.first)
  parsed_job_list = Nokogiri::HTML(unparsed_job_list.body)
  jobs = []
  parsed_job_list.css('div#search_results div.job-item.job-item-posting ').each do |job|
    info = { title: job.css('div.container-fluid div.row h3')[0].text,
             work_title: job.css('div.container-fluid div.row div.col-md-8.col-xs-12 div.col-md-2.col-xs-12.job-title.job-title-text-wrap.col-md-push-0')[0].text ,
             dept: job.css('div.container-fluid div.row div.col-md-8.col-xs-12 div.col-md-2.col-xs-12.job-title.job-title-text-wrap.col-md-push-0')[1].text,
             app_deadline: job.css('div.container-fluid div.row div.col-md-8.col-xs-12 div.col-md-2.col-xs-12.job-title.job-title-text-wrap.col-md-push-0')[2].text ,
             open_number: job.css('div.container-fluid div.row div.col-md-8.col-xs-12 div.col-md-2.col-xs-12.job-title.job-title-text-wrap.col-md-push-0')[3].text,
             target_salary: job.css('div.container-fluid div.row div.col-md-8.col-xs-12 div.col-md-2.col-xs-12.job-title.job-title-text-wrap.col-md-push-0')[4].text,
             desc: job.css('div.container-fluid div.row div.col-md-12.col-xs-12 div.details span.job-description')[1].text,
             details: 'https://www.jobsatosu.com/postings/search' + job.css('a')[0]['href']
            }
    jobs << info
  end
  jobs
end

def print_job_listings jobs
  puts "Available jobs: #{jobs.count}"
  jobs.each_with_index do |info, i|
    puts "Job listing #{i + 1}"
    puts ' Title: ' + info[:title]
    puts 'Work Title: ' + info[:work_title]
    puts 'Department: ' + info[:dept]
    puts 'Application Deadline: ' + info[:app_deadline]
    puts 'opening number: ' + info[:open_number]
    puts 'Salary: ' + info[:target_salary]
    puts 'Description :' +info[:desc]
    puts 'View Details:' +info[:details]
    end
end

job_listings = get_job_listings
print_job_listings job_listings