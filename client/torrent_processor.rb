#!/usr/bin/ruby

require 'config'
require 'transmission_helper'
require 'download_job_creator'
require 'download_job_fetcher'

class TorrentProcessor
  def initialize
    @th = TransmissionHelper.new(TransmissionConfig)
    @djc = DownloadJobCreator.new
  end

  def create_download_jobs_for_completed_files(t)
    t['files'].each do |file|
      next if file['length'] > file['bytesCompleted']

      # TODO: Remove root BT directory (/media/20...) from relative path
      dir = ftp_dir_for_torrent(t)

      attributes = {
        "download_job[title]" => "#{t['name']}/#{file['name']}",
        "download_job[tag_names]" => FtpReadyTag,
        "download_job[directory]" => dir,
        "download_job[url]" => ftp_url_for_file(file, dir)
      }

      r = @djc.create_job(attributes)
        
      if r['success']
        puts "Created job for '#{ftp_url_for_file(file, dir)}'"
      elsif r['errors'] == {"base" => ["This URL is already waiting to be downloaded"]}
        # Raise unless we get success back, or the error message expected.
        puts "Job for '#{ftp_url_for_file(file, dir)}' already exists"
      else
        raise r['errors']
      end
    end
  end
  
  def ftp_dir_for_torrent(t)
    t['downloadDir'].sub FtpFSRootRegex, ''
  end
    
  def ftp_url_for_file(file, dir)
    "#{FtpRoot}/#{dir + (dir == '' ? '' : '/')}#{file['name']}"
  end
  
  def ftp_is_complete(files, dir)
    files.each do |file|
      url = ftp_url_for_file(file, dir)
      finished = false
      waiting = false
      
      DownloadJobFetcher.new.get_download_jobs_with_url(url).each do |job|
        case job['status']
          when 'Finished' then finished = true
          when 'Not Started' then waiting = true
          when 'Retry' then waiting = true
        end
      end
      
      return false if waiting or not finished
    end
    
    true
  end
  
  def dispose_of_torrent_if_finished(torrent)
    if torrent['isFinished'] and ftp_is_complete(torrent['files'], ftp_dir_for_torrent(torrent))
      puts "Removing '#{torrent['name']}.'"
      @th.remove_torrent(torrent['id'], true)
      
      return true
    end
    
    false
  end

  def go
    @th.all_torrents.each do |t|
      puts "Torrent: #{t['name']}"
    
      disposed = dispose_of_torrent_if_finished(t)
      
      create_download_jobs_for_completed_files(t) unless disposed
    end
  end
end

TorrentProcessor.new.go

