FactoryBot.define do
  factory :submission do
    site_id { create(:site).id}
    participant_id { create(:participant).id }
    record_taken { Date.today }
    ai_tags  { {} }
    type_name { "EMAIL" }

    factory :submission_with_insta_type do
      type_name { "INSTAGRAM" }
    end

    after(:build) do |submission|
      submission.image.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'assets', 'test-image.jpg')),
        filename: 'test-image.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
end