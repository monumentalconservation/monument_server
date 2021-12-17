class SubmissionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  attributes :id, :siteName, :siteId, :recordTaken, :ai_tags, :imageUrlSmall,  :imageUrl, :typeName, :comment, :tags

  def imageUrlSmall
    variant = object.image.attachment.variant(resize_to_limit: [300, 300])
    if Rails.env == 'development'
      ActiveStorage::Current.set(host: "localhost:3000") do
        rails_representation_url(variant, only_path: true)
      end
    else
      rails_representation_url(variant, only_path: true)
    end
  end

  def imageUrl
    if Rails.env == 'development'
      ActiveStorage::Current.set(host: "localhost:3000") do
        # self.object.image.attachment.service_url
        rails_blob_path(object.image, only_path: true)
      end
    else
      rails_blob_path(object.image, only_path: true)
    end
  end

  def siteName
    self.object.site.name
  end

  def siteId
    self.object.site_id
  end

  def typeName
    self.object.type_name
  end

  def comment
    self.object.comment
  end

  def recordTaken
    self.object.record_taken
  end

  def ai_tags
    # sorts the tags by most likely, then reverses them, then splats them out as an array
    self.object.ai_tags.sort_by {|_key, value| value}.reverse
  end

  def tags
    self.object.tag_list
  end

end
