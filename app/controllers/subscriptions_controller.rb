require 'user_holder_controller'

class SubscriptionsController < ApplicationController
  include UserHolderController

  # GET /subscriptions
  # GET /subscriptions.json
  
  before_filter :login_required, :except => [:show, :index]
  before_filter :get_user
  
  def login_required
    redirect_to subscriptions_url unless session[:user_id]
  end
  
  def index
    user_ids = [nil]
    user_ids << @user.id if @user
    @subscriptions = Subscription.where(:user_id => user_ids) 
    
    if params[:tag_name]
      @tag = Tag.find_by_name params[:tag_name]
      @subscriptions = Subscription.find_by_tag(@tag.name)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @subscriptions }
    end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
    @subscription = Subscription.find(params[:id])
    
    redirect_to subscriptions_url, :notice => "Sorry. You can't see that one." unless @user == @subscription.user or @subscription.user == nil

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @subscription }
    end
  end

  # GET /subscriptions/new
  # GET /subscriptions/new.json
  def new  
    @subscription = Subscription.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @subscription }
    end
  end

  # GET /subscriptions/1/edit
  def edit
    @subscription = Subscription.find(params[:id])
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = Subscription.new(params[:subscription])

    respond_to do |format|
      if @subscription.save
        format.html { redirect_to @subscription, :notice => 'Subscription was successfully created.' }
        format.json { render :json => @subscription, :status => :created, :location => @subscription }
      else
        format.html { render :action => "new" }
        format.json { render :json => @subscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.json
  def update
    @subscription = Subscription.find(params[:id])
    
    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to @subscription, :notice => 'Subscription was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @subscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to subscriptions_url }
      format.json { head :ok }
    end
  end
end
