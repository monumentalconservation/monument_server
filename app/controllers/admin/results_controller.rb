class Admin::ResultsController < ApplicationController
  before_action :redirect_unless_admin

  def index
    @submissions = Submission.count
  end
  
end
