require 'test_helper'

class DownloadJobsControllerTest < ActionController::TestCase
  setup do
    @download_job = download_jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:download_jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create download_job" do
    assert_difference('DownloadJob.count') do
      post :create, :download_job => @download_job.attributes
    end

    assert_redirected_to download_job_path(assigns(:download_job))
  end

  test "should show download_job" do
    get :show, :id => @download_job.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @download_job.to_param
    assert_response :success
  end

  test "should update download_job" do
    put :update, :id => @download_job.to_param, :download_job => @download_job.attributes
    assert_redirected_to download_job_path(assigns(:download_job))
  end

  test "should destroy download_job" do
    assert_difference('DownloadJob.count', -1) do
      delete :destroy, :id => @download_job.to_param
    end

    assert_redirected_to download_jobs_path
  end
end
