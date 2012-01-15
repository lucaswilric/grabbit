#!/usr/bin/ruby

require 'http_fetcher'
require 'net/http'

require 'rubygems'
require 'json'

require 'config'

require 'download_job_runner'
require 'download_job_fetcher'
require 'download_job_helper'

require 'transmission_helper'
  
jobs = DownloadJobFetcher.new().get_download_jobs

puts "#{ jobs.length } item(s)."

def get_destination_for(job, subscription)
  dir_path = get_path_for job, subscription

  file_name = DownloadJobHelper.file_name(job, subscription)
  
  destination = "#{ dir_path }/#{ file_name }"
end

def get_path_for(job, subscription)
  # Copy the contents of DestinationRoot to a new instance, so we don't mutate the original.
  dir_path = String.new(DestinationRoot)
   
  dir_path << "/" + DownloadJobHelper.directory(job, subscription)
            
  dir_path = File.expand_path(dir_path.chomp('/'))

  unless dir_path.match /\A#{ DestinationRoot.chomp('/') }/
    raise "Download #{ job.id } tried to save outside '#{ DestinationRoot }', in #{ dir_path }"
  end
    
  make_directory dir_path

  dir_path
end
  
def make_directory(dir_path)
  return if File.directory? dir_path

  puts "Making directory '#{dir_path}'." 
    
  parent_path = dir_path[0..dir_path.rindex('/')].chomp('/')
  make_directory(parent_path)
    
  umask = File.umask(0000)

  Dir.mkdir(dir_path, 0777)

  File.umask(umask)
end

def add_to_transmission(job, subscription, dir)
  make_directory "#{DestinationRoot}/#{dir}"

  r = TransmissionHelper.new(TransmissionConfig).add_torrent_url(job['url'], "#{DestinationRoot}/#{dir}")
  
  puts "Added torrent '#{r['name']}'."
end

def save_file(job, subscription, dir)
  destination = get_destination_for job, subscription
  
  open(destination, "wb") do |file|
    file.write( fetch(job['url']).body )
  end

  file_name = DownloadJobHelper.file_name(job, subscription)

  puts "Downloaded #{job['url']} to #{dir}."
end

DownloadJobRunner.new().run_jobs(jobs) do |job, subscription|
  dir = DownloadJobHelper.directory(job, subscription)

  # If it's a torrent, try to add it to Transmission
  if subscription['extension'] == 'torrent'
    add_to_transmission job, subscription, dir
  else
    save_file job, subscription, dir
  end  
end

