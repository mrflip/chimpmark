#!/usr/bin/ruby

`unzip /mnt/wikidata/wikilinks/titles-sorted.zip`
i = 1
File.open('article_titles','w') do |file|  
  File.open('titles-sorted.txt').each do |line|
    file.print("#{i}\t#{line}")
    i += 1
  end
end

`hdp-put article_titles /data/rawd/wp/article_info/article_titles`
`rm article_titles`
`rm titles-sorted.txt`

