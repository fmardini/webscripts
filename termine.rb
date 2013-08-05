url1 = "http://service2.diplo.de/rktermin/extern/appointment_showMonth.do?locationCode=amma&realmId=16&categoryId=45&dateStr=01.08.2013"
url2 = "http://service2.diplo.de/rktermin/extern/appointment_showMonth.do?locationCode=amma&realmId=16&categoryId=45&dateStr=01.09.2013"

loop do
  begin
    puts("%s: Running..." % Time.now.strftime("%d/%m %H:%M"))
    [url1].each do |url|
      html = open(url).read
      doc = Nokogiri::HTML.parse(html)
      divs = doc.search("#content .wrapper").search("> div")

      appointments = []
      divs[1..-1].each do |div|
        ds = div.search("div")
        date = ds.first.search("h4").inner_html.strip
        available = ds.last.search("a").size > 0
        appointments.push(date) if available
      end

      if !appointments.empty?
        Notifier.ad_hoc("f.mardini@gmail.com", {:content => appointments.join("<br />")}, {:subject => "Appointments"}).deliver
      else
        # puts("%s: Nothing available" % Time.now.strftime("%d/%m %H:%M"))
      end
    end
  rescue Exception => e
    puts("*" * 30 + " " + e.message)
    puts(e.backtrace.join("\n"))
  end
  sleep(15 * 60)
end
