class TagsController < ApplicationController
  def show
    find_tag params[:id]
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @tag }
    end
  end
  
  def edit
    find_tag params[:id]
  end
  
  def update
   @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to @tag, :notice => 'Tag was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def find_tag(id)
    @tag = Tag.find id if id.to_i > 0
    @tag = Tag.find_by_name id unless @tag
  end
end
