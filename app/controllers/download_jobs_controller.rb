require 'feed_fetcher'
require 'user_holder_controller'
require 'net/http'

class DownloadJobsController < ApplicationController
  include UserHolderController

  protect_from_forgery :only => [ :delete ]

  before_filter :default_format_json, :only => :feed
  before_filter :login_required, :except => [:index, :show, :feed, :search] unless ENV['GRABBIT_INSECURE'] == '1'
  
  def login_required
    redirect_to(download_jobs_url, :notice => "You'll need to log in for that.") unless session[:user_id]
  end

  def default_format_json
    request.format = "json" unless params[:format]
  end

  # GET /download_jobs
  # GET /download_jobs.json
  def index
    djs = nil
    conditions = { :user_id => [nil, (@user ? @user.id : nil)] }
    order = 'download_jobs.id desc'
  
    if params[:tag_name]
      @tag = Tag.find_by_name(params[:tag_name])
      djs = @tag.download_jobs
    elsif params[:subscription_id]
      djs = Subscription.find(params[:subscription_id]).download_jobs
    end
    
    @download_jobs = (djs || DownloadJob).where(conditions).paginate(:page => params[:page]).order(order)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @download_jobs }
    end
  end
  
  # There should always be only one tag in params[].
  def feed
    @tag_name = params[:tag_name]
    @tag = Tag.find_by_name(@tag_name)

    if @tag.nil?
      @download_jobs = []
    else
      @download_jobs = @tag.download_jobs
        .where(:status => [Status[:not_started], Status[:retry]], :user_id => [nil, (@user ? @user.id : nil)])
        .order('download_jobs.id desc')
        .paginate(:page => params[:page])
    end
    
    @feed_updated_at = @download_jobs.first.updated_at || @download_jobs.first.created_at unless @download_jobs.empty?
    @feed_updated_at = Time.now unless @feed_updated_at
    
    @feed_title = (@tag.nil? || @tag.title.blank?) ? "Grabbit feed for \"#{ params[:tag_name]}\"" : @tag.title
    
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
