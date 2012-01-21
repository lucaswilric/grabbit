require 'feed_fetcher'
require 'net/http'

class DownloadJobsController < ApplicationController

  protect_from_forgery :only => [ :delete ]

  # GET /download_jobs
  # GET /download_jobs.json
  def index
    if params[:tag_name]
      @download_jobs = DownloadJob.find_by_tag(params[:tag_name]) 
    else
      @download_jobs = DownloadJob.all
    end
    
    @download_jobs.sort! {|a,b| b.created_at <=> a.created_at }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @download_jobs }
    end
  end
  
  # There should always be only one tag in params[].
  def feed
    FeedFetcher.fetch_all_feeds params[:tag_name]

    @download_jobs = DownloadJob.find_by_tag(params[:tag_name])
    
    @download_jobs.reject! {|d| not [Status[:not_started], Status[:retry]].include? d.status }
    @download_jobs.sort! {|a,b| b.created_at <=> a.created_at }
    @download_jobs = @download_jobs.first(30)
    
    render :json => @download_jobs
  end
  
  # GET /download_jobs/1
  # GET /download_jobs/1.json
  def show
    @download_job = DownloadJob.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @download_job }
    end
  end

  # GET /download_jobs/new
  # GET /download_jobs/new.json
  def new
    @download_job = DownloadJob.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @download_job }
    end
  end

  # GET /download_jobs/1/edit
  def edit
    @download_job = DownloadJob.find(params[:id])
  end

  # POST /download_jobs
  # POST /download_jobs.json
  def create
    @download_job = DownloadJob.new(params[:download_job])

    respond_to do |format|
      if @download_job.save
        format.html { redirect_to @download_job, :notice => 'Download job was successfully created.' }
        format.json { render :json => @download_job, :status => :created, :location => @download_job }
      else
        format.html { render :action => "new" }
        format.json { render :json => @download_job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /download_jobs/1
  # PUT /download_jobs/1.json
  def update
    @download_job = DownloadJob.find(params[:id])

    respond_to do |format|
      if @download_job.update_attributes(params[:download_job])
        format.html { redirect_to @download_job, :notice => 'Download job was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @download_job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /download_jobs/1
  # DELETE /download_jobs/1.json
  def destroy
    @download_job = DownloadJob.find(params[:id])
    @download_job.destroy

    respond_to do |format|
      format.html { redirect_to download_jobs_url }
      format.json { head :ok }
    end
  end
  
  def search
    @download_jobs = DownloadJob.where(:url => params[:url]).order('download_jobs.id desc').limit(10)
    
    render :json => @download_jobs
  end
end
