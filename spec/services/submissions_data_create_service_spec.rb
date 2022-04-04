# frozen_string_literal: true

require 'rails_helper'
RSpec.describe SubmissionsDataCreateService do
  describe '#create' do
    before do
      Timecop.freeze(Time.local('2020/9/1'))
    end
    
    let(:site)     { create(:site, name: "Trethevy") }
    let!(:sub_one) { create(:submission, site_id: site.id, tag_list: ["foo", "bar"]) }
    let!(:sub_two) { create(:submission, site_id: site.id, record_taken: Date.today - 1.month) }

    subject { described_class.new(Submission.all, Date.today - 1.year) }

    let(:expected_object) do
      { byMonth: [{ x: '01/19', y: 0 },
                  { x: '02/19', y: 0 },
                  { x: '03/19', y: 0 },
                  { x: '04/19', y: 0 },
                  { x: '05/19', y: 0 },
                  { x: '06/19', y: 0 },
                  { x: '07/19', y: 0 },
                  { x: '08/19', y: 0 },
                  { x: '09/19', y: 0 },
                  { x: '10/19', y: 0 },
                  { x: '11/19', y: 0 },
                  { x: '12/19', y: 1 },
                  { x: '01/20', y: 1 }],
        tagsMost: [{"x"=>1, "y"=>"foo"}, {"x"=>1, "y"=>"bar"}],
        tagsLeast: [{"x"=>1, "y"=>"foo"}, {"x"=>1, "y"=>"bar"}],
        siteCounts: [{"x"=>"Trethevy", "y"=>2}],
        maxSubs: ['Trethevy'],
        minSubs: ['Trethevy'] }
    end


    after do
      Timecop.return
    end

    it 'creates this object' do
      expect(subject.create).to eq expected_object
    end
  end
end
