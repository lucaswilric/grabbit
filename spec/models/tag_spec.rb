require 'spec_helper'

describe Tag do

	def valid_download_job(tag_names, p = {})
		@num = (@num || 0) + 1
	
		dj = DownloadJob.create(
			:title => p[:title] || 'DJ'+@num.to_s,
			:url => p[:url] || 'url'+@num.to_s,
			:tag_names => tag_names,
			:user => p[:user]
		)
		
		if p[:status]
			dj.status = p[:status]
			dj.save
		end

		dj
	end

	before :each do
		Tag.delete_all
		DownloadJob.delete_all
		User.delete_all
		
		@tag = Tag.create(
			:name => 'blurp'
		)
	end
			
  context "when getting download_jobs for a feed" do
  	before :each do
			@retry = valid_download_job('blurp', :status => 'Retry')		
			@finished = valid_download_job('blurp', :status => 'Finished')
			@cancelled = valid_download_job('blurp', :status => 'Cancelled')
			@in_progress = valid_download_job('blurp', :status => 'In Progress')
			
			@other_tag = valid_download_job('fernty')
			@multiple_tags_one_matching = valid_download_job('blurp, fernty')
			
			# Make sure these ones are last. Kind of important.
			@recent1 = valid_download_job('blurp')
			@recent2 = valid_download_job('blurp')
			@recent3 = valid_download_job('blurp')
  	end
  	
  	it "only returns DJs that have the specified tag" do
  		djs = @tag.download_jobs_for_feed(10)
  		
  		djs.should include @recent3
  		djs.should_not include @other_tag
  	end
  	
  	it "returns DJs that have other tags as well" do
			djs = @tag.download_jobs_for_feed(10)
			
  		djs.should include @multiple_tags_one_matching
  	end
  	
  	it "returns the specified number of download_jobs" do
			djs = @tag.download_jobs_for_feed(2)

  		djs.should have(2).things
  	end
  	
  	it "returns download_jobs ordered by recency" do
			djs = @tag.download_jobs_for_feed(2)

  		djs[0].should == @recent3
  		djs[1].should == @recent2
  	end
  	
  	it "only returns Not Started or Retry download_jobs" do			
			djs = @tag.download_jobs_for_feed(10)

			djs.should_not include @finished
			djs.should_not include @in_progress
			djs.should_not include @cancelled
			
			djs.should include @retry
			djs.should include @recent1
  	end
  	
  	it "only returns public DJs, or those belonging to me" do
  		@me = User.create(:name => 'me', :open_id => 'flurn')
  		@someone_else = User.create(:name => 'someone else', :open_id => 'grimp')
  		
  		@mine = valid_download_job('blurp', :user => @me, :title => 'MMMMIIIINNNNEEEE')
  		@hers = valid_download_job('blurp', :user => @someone_else, :title => 'HHHHEEEERRRRSSS')
  		
  		djs = @tag.download_jobs_for_feed(20, @me)
  		
  		djs.should include @mine
  		djs.should include @recent1
  		djs.should_not include @hers
  	end
  end
end
