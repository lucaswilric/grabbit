#!/usr/bin/ruby

require 'http_fetcher'
require 'net/http'

require 'rubygems'
require 'json'

require 'config'

require 'download_job_runner'
require 'download_job_fetcher'
require 'download_job_helper'
  
jobs = DownloadJobFetcher.new().get_download_jobs

puts "#{ jobs.length } item(s)."

DownloadJobRunner.new().run_jobs(jobs, false) do |job, subscription|
  dir = DownloadJobHelper.directory(job, subscription)
  file_name = DownloadJobHelper.file_name(job, subscription)

  puts "Downloaded #{job['url']} to #{dir}."
  
  # If it's a torrent, try to add it to Transmission
  if file_name.match(/.torrent\Z/)
    TransmissionHelper.new(TransmissionConfig).add_torrent(dir, file_name)
  end  
end

