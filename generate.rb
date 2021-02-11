#!/usr/bin/env ruby

require 'kramdown'
require 'tempfile'

LINK_REGEXP = /\[\[\s*(\S+)\s*\]\]/
MARKDOWN_TEMPLATE = "# %s"

def generate_required_markdown_files_from_magic_links_in_markdown_file(markdown_file)
  markdown_file_contents = File.read(markdown_file)

  markdown_file_contents.to_enum(:scan, LINK_REGEXP).map { Regexp.last_match }.each do |markdown_file_link|
    markdown_title = markdown_file_link[1]
    markdown_file_to_create = "#{markdown_title}.md"

    unless File.exist? markdown_file_to_create
      File.open(markdown_file_to_create, 'w') do |f|
        f.write(MARKDOWN_TEMPLATE % markdown_title)
      end
    end
  end
end

def generate_html_file_from_markdown(markdown_file)
  markdown_file_contents = File.read(markdown_file).gsub(LINK_REGEXP, '[\1](\1.html)')

  html_file = markdown_file.gsub(".md", ".html")
  html_file_contents = Kramdown::Document.new(markdown_file_contents).to_html

  File.open(html_file, "w") do |f|
    f.write(html_file_contents)
  end
end

puts "Generating site..."

Dir.glob("*.md").each do |markdown_file|
  generate_required_markdown_files_from_magic_links_in_markdown_file markdown_file
end

Dir.glob("*.md").each do |markdown_file|
  generate_html_file_from_markdown markdown_file
end
