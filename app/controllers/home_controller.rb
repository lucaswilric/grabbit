class HomeController < ApplicationController
  def index
    @dj_count = DownloadJob.where('created_at > ?', 2.weeks.ago).count
    @sub_count = Subscription.count
    @tag_count = Tag.count
  end
end
