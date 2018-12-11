FactoryBot.define do
  factory :site do
    name { 'Some Stones' }
    pic_id { '123rth' }
    latitude { 12.123 }
    longitude { - 12.123 }
    notes  { 'We are looking at these stones' }
  end
end