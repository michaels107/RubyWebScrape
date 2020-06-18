# Project 3
### Web Scraping

### Roles
* Overall Project Manager: Duytan Tran
* Implementation Manager: Caroline Wheeler
* Testing Manager: Reema Gupta
* Documentation: Sean Michaels

### Contributions
* Web scraping for OSU's Student Job Board listings and accompanying print method (student_job_search.rb), pulling together of job scrapes in CombinedSearches class (combined_searches.rb), implementation of the compare_listings method (combined_searches.rb), and system testings for OSU Student Job Board scraping, printing, and compare_listings (systems_testing.txt): Duytan Tran

* Creation of scrape.rb, Initial selection of what to scrape (scrape.rb), filtering the scrape of the Student Job board (student_job_search.rb), printing to a file method for both Student Job Board and OSU employment job board(job.rb and student_job_search.rb), creating a method in the class for printing to a file using overloading(combined_searches.rb), system testings for these additions (systems_testing.txt) : Sean Michaels 

* Web scraping for OSU Job Board listings accomanying print method (job.rb), created a method for emailing the printed file for both Student Job Board and OSU employment job board (combined_searches.rb), included details for calling the email method in (scrape.rb), and system testing for these additions(system_testing.txt):Reema Gupta

* Filtering of OSU Job Board listing - includes 4 methods and a block of code in scraping method (job.rb), implementation of pick_favorites (combined_searches.rb), as well as the accompanying ability to print favorites (scrape.rb), and system testing for filtering of OSU Job Board Searches, (systems_testing.txt): Caroline Wheeler

### How to execute
1. Install the bundler gem if you haven't already: http://web.cse.ohio-state.edu/~shareef.1/3901.su20/labs/gems.html
2. Move into the Project-3-Quaranteam directory via terminal command: cd your_file_path
3. Install releveant gems used in our program via terminal command: bundle install
4. Fulfill the bookkeeping required by rbenv via terminal command: rbenv rehash
5. Run the program using the right gems via terminal command: bundle exec ruby scrape.rb

### Walkthrough
1. Once you start the program, you will be prompted asking which job scrape you would like to use.
2. After selecting your designated scrape, it will ask you to enter some filters on the scrape if you would like.
3. After doing your filtering of for your scrape, it will then prompt you for some different options you can do from your scrape.

    3a. If you selected '1', it will print out all the jobs into the console with their data.
  
    3b. If you selected '2', it will ask you to select two jobs in which it will then print to the console the two jobs side by side for you compare.

    3c. If you selected '3', it will ask you to input a file name for it to create and print all the jobs that it had scrape, to that file.

    3i. When selectiong option '3', it will ask you to  if you want to send the file as an email. If selecting 'Y' it will then prompt for a email id and will then send you an email with the file. If you select 'N', it will not send an email.

    3d. If you selected '4', it will ask you to select your favorite jobs and it will write them into the favorites file.

    3e. If you selected '5', it will then print the jobs in your favorites file to a file.

4. It will then loop with the same options until you decide that you want to quit. When deciding that you want to quit, enter 'q' as the choice and the program will proceed to quit.


### Gmail Login Credentials
* Email id: quaranteamcse3901@gmail.com
* Password: Quaranteam3901

1. Make sure that access to less secure apps is turned on. For that, after logging in to the account go to following link and turn on https://www.google.com/settings/security/lesssecureapps

