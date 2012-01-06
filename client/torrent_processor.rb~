#!/usr/bin/ruby

require 'config'
require 'transmission_helper'
require 'download_job_creator'

class TorrentProcessor
  def initialize
    @th = TransmissionHelper.new(TransmissionConfig)
    @djc = DownloadJobCreator.new
  end

  def go
    @th.all_torrents.each do |t|
      puts "Torrent: #{t['name']}"
    
      t['files'].each do |file|
        next if file['length'] > file['bytesCompleted']

        # TODO: Remove root BT directory (/media/20...) from relative path
        dir = t['downloadDir'].sub FtpFSRootRegex, ''

        attributes = {
          "download_job[title]" => "#{t['name']}/#{file['name']}",
          "download_job[tag_names]" => "media",
          "download_job[directory]" => dir,
          "download_job[url]" => "#{FtpRoot}/#{dir}#{dir==''?'':'/'}#{file['name']}"
        }

        puts "Creating job for '#{FtpRoot}/#{dir}#{dir==''?'':'/'}#{file['name']}'"
        r = @djc.create_job(attributes)
        
        # Raise unless we get success back, or the error message expected.
        raise r['errors'] unless r['success'] or r['errors'] == {"base" => ["This URL is already waiting to be downloaded"]}
      end
    end
  end
end

TorrentProcessor.new.go

