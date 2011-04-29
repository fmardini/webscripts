require 'rubygems'
require 'hpricot'
require 'addressable/uri'
require 'open-uri'
require 'sanitize'

base_url = 'http://www.evene.fr/citations/auteur.php?ida=40'

doc = Hpricot(open(base_url).read)
pages = doc.search("html body div div.page div#left.content table:last tr td.B13 a.B13")
urls = {}
pages.each { |page| urls[Addressable::URI.join(base_url, page[:href])] = true }

def get_quotes(doc)
  quotes = doc.search("html body div div.page div#left.content table:last tr td span.N12.txtNr")
  qs = []
  quotes.each { |q| qs << Sanitize.clean(q.inner_html) }
  qs
end

File.open('quotes.txt', 'w') do |f|
  [doc].concat(urls.keys.map { |u| Hpricot(open(u).read) }).each do |d|
    get_quotes(d).each do |q|
      f.puts q
    end
  end
end
