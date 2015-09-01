require 'watir-webdriver'


def prettify_display(subjects)
	printf("%-40s    %5s\t%5s\t%5s\t%5s\n","SUBJECT","TOTAL","ATTENDED","BUNKED","PERCENTAGE")

	subjects.each do |subject|
		all = subject.split("^")
		all[3] = (all[1].to_i) - (all[2].to_i)
		all[4] = (all[3])/(all[1].to_i) * 100;
		all[3]=all[3].to_s
		all[4]=all[4].to_s
		printf("%-40s -> %5s\t%5s\t%5s\t%5s\n",all[0],all[1],all[2],all[3],all[4])
	end
end

# Set up browser to LOGIN and Scrape Data
browser = Watir::Browser.new
browser = Watir::Browser.start("http://my-gurukul.com/login.aspx?BROWSERWINDOW=&BROWSER=FF&DF=MM/DD/YYYY&CF=MYGURUKUL")

# Use arguments as login
login=ARGV[0].split(" ");
browser.text_field(:name => 'txtUserName').set login[0]
browser.text_field(:name => 'txtPassword').set login[1]
b = browser.button(:id, "Validate").click

# Proceed to Attendance View and Capture Chart Data
browser.goto "http://my-gurukul.com/frmattendanceview.aspx"
content = browser.hidden(:id => "hdn_ChartData").value
content.strip!

# Prepare for Long term file storage purpose with time
current_date = Date.today.to_s
storage = "#{current_date}^#{content}|"
subjects = content.split(";")

# Display to Console
prettify_display subjects

browser.close
File.open("res.html", 'w') { |file| file.write(final) }


