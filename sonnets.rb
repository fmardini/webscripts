require 'rubygems'
require 'hpricot'
require 'addressable/uri'
require 'open-uri'
require 'sanitize'

base_url = 'http://www.shakespeares-sonnets.com/sonnet/all.php'

doc  = Hpricot(open(base_url).read)
ps   = doc.search("html body div#main div.section p")

File.open('sonnets.txt', 'w') do |f|
  ps.each do |par|
    if par.search('br').length > 0
      par.inner_html.split('<br />').each { |l| f.puts(l.gsub(/[\n\r]/, '').strip) }
    else
      f.puts(par.inner_html.empty? ? "=" * 80 : par.at('a').inner_html)
    end
  end
end
