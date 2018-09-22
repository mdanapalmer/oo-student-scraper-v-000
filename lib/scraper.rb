require 'open-uri'
require'pry'
class Scraper

  def self.scrape_index_page(index_url)
    #why aren't we using the url here?
    index_page = Nokogiri::HTML(open(index_url))
    #converts the open-uri into Nokogiri's ability to parse the html as nested arrays and names that var index_page
    students = []
    #creates an empty student array
    index_page.css("div.roster-cards-container").each do |card|
      binding.pry
      #calls the .css method on each element in the html container of index_page
      #iterates over them with each element referenced as card
      card.css(".student-card a").each do |student|
        #also calls the.css notation and iterates on the nested array of card into student
        #so that we can now access our student attributes
        student_profile_link = "#{student.attr('href')}"
        #interpolates the href into the var
        student_location = student.css('.student-location').text
        #digs into the student.css array to extract the location text and name it student_location
        student_name = student.css('.student-name').text
        #obtains student_name text from the .css array student
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
        #shovels the hash for name, location, and profile_url into the students array
      end
    end
    students
    #returns the students array
  end

  def self.scrape_profile_page(profile_slug)
    student = {}
    profile_page = Nokogiri::HTML(open(profile_slug))
    links = profile_page.css(".social-icon-container").children.css("a").map { |el| el.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end
    # student[:twitter] = profile_page.css(".social-icon-container").children.css("a")[0].attribute("href").value
    # # if profile_page.css(".social-icon-container").children.css("a")[0]
    # student[:linkedin] = profile_page.css(".social-icon-container").children.css("a")[1].attribute("href").value if profile_page.css(".social-icon-container").children.css("a")[1]
    # student[:github] = profile_page.css(".social-icon-container").children.css("a")[2].attribute("href").value if profile_page.css(".social-icon-container").children.css("a")[2]
    # student[:blog] = profile_page.css(".social-icon-container").children.css("a")[3].attribute("href").value if profile_page.css(".social-icon-container").children.css("a")[3]
    student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")

    student
  end

end
