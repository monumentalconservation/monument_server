# TODO: - rename this reports controller or something
class Admin::CsvController < ApplicationController # TODO: - make these all background jobs
  def basic_submission
    # returns basic report with all submissions
    respond_to do |format|
      format.csv { send_data create_basic_submissions_report, filename: "basic-submissions-#{Date.today}.csv" }
    end
  end

  def participant_report
    # returns report with breakdown of participation
    respond_to do |format|
      format.csv { send_data create_participant_report, filename: "participant-report-#{Date.today}.csv" }
    end
  end

  def site_specific_time_period
    # returns report of submissions over specific time period (probably unessecary)
    return unless params[:site_id].present?

    name = Site.find(params[:site_id]).name

    respond_to do |format|
      format.csv { send_data create_specific_site_time_period_report(params[:site_id], params[:from_date], params[:to_date]), filename: "submissions-for-#{name}-tags-#{Date.today}.csv" }
    end
  end

  def site_specific_tags
    return unless params[:site_id].present?

    name = Site.find(params[:site_id]).name
    respond_to do |format|
      format.csv { send_data create_specific_site_tag_report(params[:site_id], params[:from_date], params[:to_date]), filename: "submissions-for-#{name}-#{Date.today}.csv" }
    end
  end

  def tags_report
    return unless params[:site_id].present? || params[:tag].present?

    site = params[:site_id] ? '' : Site.find(params[:site_id])

    respond_to do |format|
      format.csv { send_data create_tags_report(site, params[:tag]), filename: "tag-report-#{params['tag']}-#{site}#{Date.today}.csv" }
    end
  end

  def image_quality
    respond_to do |format|
      format.csv { send_data create_image_quality_report(params[:type_name]), filename: "image-quality-#{params[:type_name].downcase}-#{Date.today}.csv" }
    end
  end

  # only really specific to clava and machrie
  def at_home
    # returns report of submissions over specific time period, alongside details of 'at home' campaign
    # binding.pry
    return unless params[:site_id].present?

    name = Site.find(params[:site_id]).name

    respond_to do |format|
      format.csv { send_data create_site_report_with_at_home(params[:site_id], params[:from_date], params[:to_date]), filename: "submissions-for-#{name}-tags-#{Date.today}.csv" }
    end
  end

  private

  def create_basic_submissions_report
    attributes = %w[submission-id site-name record-taken record-submitted type-name at-home]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      Submission.all.each do |submission|
        submitted_at = submission.submitted_at.present? ? submission.submitted_at : submission.record_taken
        row = [submission.id, submission.site_name, submission.record_taken.strftime('%d/%m/%Y'), submitted_at.strftime('%d/%m/%Y'), submission.type_name, submission.tag_list.include?("at home")]
        csv << row
      end
    end
  end

  def create_participant_report
    attributes = %w[user-id type submission-numbers records-taken]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      participants = Participant.all
      participants.map do |user|
        submissions = user.submissions
        type = submissions.try(:first).try(:type_name)
        count = submissions.count
        records_taken = submissions.map { |s| s.record_taken.strftime('%d/%m/%Y') }.uniq.flatten

        row = [user.id, type, count] + records_taken
        csv << row
      end
    end
  end

  def create_specific_site_time_period_report(site_id, from_date, to_date)
    attributes = %w[date submissions ind-submitters]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      submissions_hash = {}
      submissions ||= Submission.
                      where(site_id: site_id).
                      where('record_taken >= :start_date AND created_at <= :end_date',
                            { start_date: Date.today - 1.year, end_date: Date.today })
                                .order(:record_taken)

      (from_date.to_date).upto(to_date.to_date) do |date|
        subs = submissions.where(record_taken: date)
        total_subs = subs.count
        unique_submitters = subs.map { |s| s.participant }.uniq.count

        csv << [date.strftime('%d/%m/%Y'), total_subs, unique_submitters]
      end
    end
  end

  # With tags
  def create_specific_site_tag_report(site_id, from_date, to_date)
    attributes = %w[date tags]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      submissions = Submission.
                    where(site_id: site_id).
                    where('record_taken >= :start_date AND created_at <= :end_date',
                          { start_date: from_date, end_date: to_date }).
                    order(:record_taken)

      submissions.each do |sub|
        info = [sub.record_taken.strftime('%d/%m/%Y'), sub.tag_list]
        csv << info
      end
    end
  end

  # Just tag reports
  def create_tags_report(site, tag)
    attributes = %w[submission-id date url other-tags-on-image]

    if site.empty? && tag
      # get all the submissions from a with that tag
      submissions = Submission.all.tagged_with(tag)
    elsif site && tag
      submissions = site.submissions.tagged_with(tag)
    end

    CSV.generate(headers: true) do |csv|
      csv << attributes
      submissions.each do |sub|
        # removes the tag searched on
        tag_list = sub.tag_list
        tag_list.delete(tag)
        csv << [sub.id, sub.record_taken.strftime('%d/%m/%Y'), sub.image_url] + tag_list
      end
    end
  end

  def create_site_report_with_at_home(site_id, from_date, to_date)
    attributes = %w[submission-id site-name record-taken record-submitted participant-id at-home relevant]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      site = Site.find(site_id)
      submissions ||= site.submissions
                          .where('submitted_at >= :start_date AND created_at <= :end_date', 
                            { start_date: from_date, end_date: to_date })


     submissions.each do |sub|
      csv << [sub.id, site.name, sub.record_taken, sub.submitted_at, sub.participant_id, sub.at_home?, relevant(sub)]
     end
    end
  end

  def relevant(submission)
    # Specific only to HS paper - unessecary and should be removed at a later date
    (submission.tag_list & ["circle 6", "circle 3", "cairn entrance", "central SS"]).any?
  end

  def create_image_quality_report(type_params)
    attributes = %w[submission-id width height size resolution make model]
    submissions = Submission.where(type_name: type_params)
    CSV.generate(headers: true) do |csv|
      csv << attributes

      submissions.each do |sub|
        metadata = sub.metadata
        csv << [sub.id, metadata['width'], metadata['height'], metadata['size'], metadata['resolution'], metadata['make'], metadata['model']]
      end
    end
  end
end
