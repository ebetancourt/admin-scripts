#!/usr/bin/env ruby

# This is a script that does an SVN list of a given directory
# (ideally to list available builds to push, designed to integrate with phing)

require 'rubygems'
require 'smart_colored/extend'

module LastN
  def last(n)
    self[-n,n]
  end
  
  def trim()
    self.strip! || self
  end
end

class String
  include LastN
end

svnList = `svn list http://svn.domain.com/svn`
$i      = 0
$values = Array.new
$prompt = "\n\n\n\n\n\n" + 'Please select a build'.white + "\n\n"
$build  = 0

svnList.each_line do |line|
  if (line.trim().last(1) != '/')
    next
  end
  $i = ($i+1)
  padding = ($i <= 9) ? ' ' : ''
  $values.push line.sub('/','').to_s
  $prompt = $prompt.to_s + '['.yellow + $i.to_s.yellow + ']   '.yellow + padding.to_s + line.sub('/','').to_s.cyan + "\n"
end

begin
  puts $prompt
  puts ''
  $build = gets.strip
  $index = ($build.to_i) - 1
end while ($values.fetch($index,nil) == nil || $index < 0)
puts "\n\n" + 'You chose to build '.red + $values[$index].to_s.red