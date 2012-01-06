#!/usr/bin/ruby

require 'transmission_helper'

require 'rubygems'
require 'json'

th = TransmissionHelper.new "url" => "http://localhost:9091/transmission/rpc", "username" => "transmission", "password" => "UmzHJ8FQ"

p th.add_torrent '/media/20D0FF1ED0FEF93C/Downloads/audiobooks', 'librivox - the return of sherlock holmes - sir arthur conan doyle.torrent'


#th.all_torrents.each do |t|
#  puts "Torrent: #{ t['name'] }"
#  puts "Files:   #{ t['files'].length }"
#  
#  t['files'].each do |file|
#    readiness = file['length'] > file['bytesCompleted'] ? "not ready" : "ready"
#  
#    puts "       - #{ file['name'] } is #{readiness} for transfer."
#  end
#  
#  puts ""
#  
#end


