class ImageVariantWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform(submission)
    return unless submission&.image&.attached?
    variant = upload.image.variant(resize_to_limit: [200, nil])
    
    # This is what triggers the actual transform/cache process
    was_processed = variant.processed
    Rails.logger.info "Processed variant for #{upload.id}" if was_processed
  end
end
