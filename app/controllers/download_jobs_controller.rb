require 'feed_fetcher'
require 'user_holder_controller'
require 'net/http'

class DownloadJobsController < ApplicationController
  include UserHolderController

  protect_from_forgery :only => [ :delete ]

  before_filter :default_format_json, :only => :feed
  before_filter :login_required, :except => [:index, :show, :feed, :search]
  before_filter :get_user
  
  def login_required
    redirect_to download_jobs_url unless session[:user_id]
  end

  def default_format_json
    request.format = "json" unless params[:format]
  end

  # GET /download_jobs
  # GET /download_jobs.json
  def index
    if params[:tag_name]
      @download_jobs = Tag.find_by_name(params[:tag_name]).download_jobs.order('download_jobs.id desc').limit(100)
    else
      @download_jobs = DownloadJob.order('download_jobs.id desc').limit(100)
    end
    
    @download_jobs.reject! {|d| d.user and d.user != @user}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @download_jobs }
    end
  end
  
  # There should always be only one tag in params[].
  def feed
    @tag_name = params[:tag_name]

    @download_jobs = Tag.find_by_name(@tag_name).download_jobs_for_feed(30, @user)
    
    @feed_updated_at = @download_jobs.first.updated_at || @download_jobs.first.created_at unless @download_jobs.empty?
    @feed_updated_at = Time.now unless @feed_updated_at
    
    respond_to do |format|
      format.json { render :json => @download_jobs }
      format.rss { render :layout => false }
    end
  end
  
  # GET /download_jobs/1
  # GET /download_jobs/1.json
  def show
    @download_job = DownloadJob.find(params[:id])
    
    redirect_to download_jobs_url, :notice => "Sorry, you can't see that one." if @download_job.user and @download_job.user != @user

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
    user_ids = [nil]
    user_ids << @user.id if @user
    @download_jobs = DownloadJob.where(:url => params[:url], :user_id => user_ids).order('download_jobs.id desc').limit(10)
    
    render :json => @download_jobs
  end
end
