class Admin::ResultsController < ApplicationController

  def index
    @type_numbers = create_type_numbers_array
    @site_numbers = create_site_numbers
  end
  


  private

  def create_type_numbers_array
    Submission::TYPE_NAMES.map do |name|
      Submission.where(type_name: name ).count
    end
  end

  def create_site_numbers
    Site.all.map do |site|
      {
        name: site.name, 
        submissions: site.submissions.count,
      }
    end
  end
end
