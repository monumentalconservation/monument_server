# frozen_string_literal: true

class SubmissionsDataCreateService
  def initialize(submissions, date)
    @submissions = submissions
    @date = date
  end

  def create
    {
      byMonth: create_date_hash(@submissions, @date, 'record_taken'),
      tagsMost: most_tags_object, 
      tagsLeast: least_tags_object,
      siteCounts: site_count_object,
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

  def most_tags_object
    ActsAsTaggableOn::Tag.most_used(7).map {|a| {"x" => a.taggings_count, "y" => a.name, }}
  end

  def least_tags_object
    ActsAsTaggableOn::Tag.least_used(7).map {|a| {"x" => a.taggings_count, "y" => a.name, }}
  end

  def top_scores_object
    scores.first(4).map(&:site).map(&:name)
  end

  def bottom_scores_object
    scores.last(4).map(&:site).map(&:name)
  end

  def site_count_object
    object = Site.joins(:submissions).group('sites.id').count
    object.map {|k,v| {"x" => Site.find(k).name, "y" => v}}
  end

  def scores
    @scores ||= @submissions.select(:site_id).group(:site_id).order('count(site_id) desc')
  end
end
