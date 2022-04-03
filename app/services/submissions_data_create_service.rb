# frozen_string_literal: true

class SubmissionsDataCreateService
  def initialize(submissions, date)
    @submissions = submissions
    @date = date
  end

  def create
    {
      byMonth: create_date_hash(@submissions, @date, 'record_taken'),
      aiTags: ai_tags_object, # WHY IS THIS A DIFFERENT CASE!
      maxSubs: top_scores_object,
      minSubs: bottom_scores_object
    }
  end

  private

  def create_date_hash(collection, date, column)
    date_hash = Hash[(0..12).collect { |n| [date.advance(months: n).strftime('%m/%y'), 0] }]
    collection_by_months = collection.group("TO_CHAR(#{column}, 'MM/YY')").count.sort

    date_hash.map do |k, _v|
      { x: k, y: collection_by_months.to_h[k] || 0 }
    end
  end

  def ai_tags_object
    @submissions.tag_counts_on(:tags).map {|a| {"x" => a.taggings_count, "y" => a.name, }}
  end

  def top_scores_object
    scores.first(4).map(&:site).map(&:name)
  end

  def bottom_scores_object
    scores.last(4).map(&:site).map(&:name)
  end

  def scores
    @scores ||= @submissions.select(:site_id).group(:site_id).order('count(site_id) desc')
  end
end
