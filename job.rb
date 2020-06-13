require 'mechanize'
# Created 6/11/2020 by Reema Gupta
# Edited  6/12/2020 by Reema Gupta: Added methods for getting and printing the job list
# Edited  6/13/2020 by Reema Gupta: Changed forms.last to forms.fast and edited css parts
# Edited  6/13/2020 by Duytran Tran: Added.strip! to info values, shortened layering into a variable
# Edited  6/13/2020 by Reema Gupta: Included code so as to run the loop for all pages on the website
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
  page=1
  job_list=parsed_job_list.css('div.job-item.job-item-posting')
  per_page=job_list.count
  total=parsed_job_list.css('span.smaller.muted').text.split("(")[1].split(")")[0].to_i
  last_page=(total.to_f/per_page.to_f).round
  while page<=last_page
    pagination_url="https://www.jobsatosu.com/postings/search?commit=Search&page=#{page}"
    pagination_search_page = a.get(pagination_url)
    pagination_parsed_job_list = Nokogiri::HTML(pagination_search_page.body)
    pagination_job_list=pagination_parsed_job_list.css('div.job-item.job-item-posting')
    pagination_job_list.css('div.job-item.job-item-posting').each do |job|
      job_layering = 'div.col-md-8.col-xs-12 div.col-md-2.col-xs-12.job-title.job-title-text-wrap.col-md-push-0'
    info = {
             title: job.css('h3').text.strip!,
             work_title: job.css(job_layering)[0].text.strip! ,
             dept: job.css(job_layering)[1].text.strip!,
             app_deadline: job.css(job_layering)[2].text.strip!,
             open_number: job.css(job_layering)[3].text.strip!,
             target_salary: job.css(job_layering)[4].text.strip!,
             desc: job.css('span.job-description').text.strip!,
             details: 'https://www.jobsatosu.com' + job.css('a')[0]['href']}
    jobs << info
  end
  page +=1
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
    puts 'Description:' +info[:desc]
    puts 'View Details:' +info[:details] + "\n\n"
    end
end

job_listings = get_job_listings
print_job_listings job_listings