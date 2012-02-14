#!/usr/bin/ruby

require 'net/ftp'

require './config'
require './download_job_helper'
require './download_job_runner'
require './download_job_fetcher'

def safize(text)
  text.gsub(/ /, '%20').gsub(/\[/, '%5B').gsub(/\]/, '%5D')
end

def unsafize(text)
  text.gsub(/%20/, ' ').gsub(/%5B/, '[').gsub(/%5D/, ']')
end

path_parser = /(.*)\/([^\/]+)\Z/

jobs = DownloadJobFetcher.new(FtpReadyTag).get_download_jobs()

puts "#{ jobs.length } item(s)."

DownloadJobRunner.new().run_jobs(jobs.first(5)) do |job, subscription|
  uri = URI.parse safize(job['url'])
  directory = unsafize uri.path.sub(path_parser, '\1')
  file_name = unsafize uri.path.sub(path_parser, '\2')
  
  puts "Getting '#{file_name}' from '#{directory}'."
  
  destination = FtpDestinationRoot + directory.sub(/\ADownloads\//, '')
  DownloadJobHelper.make_directory destination
  
  ftp = Net::FTP.new uri.host
  ftp.login
  ftp.chdir directory
  ftp.get file_name, destination + '/' + file_name
  ftp.close
  
  puts "Downloaded #{job['url']} to #{destination}."
end
