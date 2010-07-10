#!/usr/bin/env ruby
require 'rubygems'
require 'wukong'
require 'nokogiri'
require 'wukong/encoding'

class WikipediaXmlArticle
  attr_accessor :xml_doc
  def initialize raw_xml
    begin
      self.xml_doc = Nokogiri::XML(raw_xml)
    rescue StandardError => e
      warn e
    end
  end


  def title()                   xml_doc.at_xpath("/page/title").inner_text rescue nil ; end
  def page_id()                 @page_id ||= xml_doc.at_xpath("/page/id").inner_text rescue nil ; end
  def redirect()                xml_doc.at_xpath("/page/redirect").inner_text rescue nil ; end
  def revision_id()             xml_doc.at_xpath("/page/revision/id").inner_text rescue nil ; end
  def revision_timestamp()      @revision_timestamp ||= Time.parse(xml_doc.at_xpath("/page/revision/timestamp").to_s).to_flat rescue nil ; end
  def revision_username()       xml_doc.at_xpath("/page/revision/contributor/username").inner_text rescue nil ; end
  def revision_contributor_id() xml_doc.at_xpath("/page/revision/contributor/id").inner_text rescue nil ; end
  def revision_comment()        xml_doc.at_xpath("/page/revision/comment").inner_text rescue nil ; end
  def unencoded_text()
    @unencoded_text ||= xml_doc.xpath("/page/revision/text").inner_text rescue ''
  end
  def text
    @text = Wukong::encode_str(unencoded_text)
  end

  def to_flat
    [page_id, redirect,
      revision_id,
      revision_timestamp,
      title,
      revision_contributor_id,
      revision_username,
      revision_comment, revision_text
    ]
  end

  #
  # Emit individual usages in the article's text
  #
  # This is pretty simpleminded:
  # * downcase the word
  # * Split at any non-alphanumeric boundary, including '_'
  # * However, preserve the special cases of 's or 't at the end of a
  #   word.
  #
  #   article.text
  #   # => "Jim's dawg won't hunt: dawg_hunt error #3007a4"
  #   article.tokenize
  #   # => ["jim's", "dawd", "won't", "hunt", "dawg", "hunt", "error", "3007a4"]
  #
  def tokenize
    return [] if unencoded_text.blank?
    # kill off all punctuation except [stuff]'s or [stuff]'t
    # this includes hyphens (words are split)
    str = unencoded_text.
      downcase.
      gsub(/[^a-zA-Z0-9\']+/, ' ').
      gsub(/(\w)\'([st])\b/, '\1!\2').gsub(/\'/, ' ').gsub(/!/, "'")
    # Busticate at whitespace
    words = str.strip.split(/\s+/)
    words.reject!{|w| w.length < 3 }
    words.map!{|w| Wukong::encode_str(w) }
  end

end


class WikipediaArticleToFlat < Wukong::Streamer::LineStreamer
  def process line
    article = WikipediaXmlArticle.new(line)
    yield article.to_flat
  end
end

class WikipediaArticleTokenMapper < Wukong::Streamer::LineStreamer
  def process line
    article = WikipediaXmlArticle.new(line)
    article.tokenize.each{|word| yield([word, article.page_id]) }
  end
end

class WikipediaArticleTokenReducer < Wukong::Streamer::AccumulatingReducer
  attr_accessor :pages
  attr_accessor :n_usages

  def start! *_
    self.pages  = Set.new
    self.n_usages = 0
  end

  def accumulate word, page_id, *_
    self.pages << page_id
    self.n_usages += 1
  end

  def finalize
    yield [key, n_usages, pages.to_a.join(',')]
  end
end


Wukong::Script.new(
  WikipediaArticleTokenMapper,
  WikipediaArticleTokenReducer,
  :partition_fields => 1,
  :sort_fields      => 2,
  :io_sort_record_percent => '0.40',
  :io_sort_mb             => '350'
  ).run
