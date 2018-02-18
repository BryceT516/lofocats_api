require 'spec_helper'

describe Api::V1::MonthlyStatsController do
  describe "GET #index" do
    before do
      40.times do |i|
        FactoryGirl.create(:cat_entry, :breed => "Breed #{i}", :user => FactoryGirl.create(:user,
         :email => "user#{i}@lofocats.com"),
         event_type: 'found',
         event_date: i.days.ago,
         created_at: i.days.ago)
      end

      40.times do |i|
        FactoryGirl.create(:cat_entry, :breed => "Breed #{3 + i}", :resolved => true, :user => FactoryGirl.create(:user,
          :email => "user#{40 + i}@lofocats.com"),
          event_type: 'lost',
          event_date: i.days.ago,
          created_at: i.days.ago)
      end
      
      40.times do |i|
        FactoryGirl.create(:cat_entry, :breed => "Breed #{3 + i}", :user => FactoryGirl.create(:user,
          :email => "user#{80 + i}@lofocats.com"),
          event_type: 'lost',
          event_date: i.days.ago,
          created_at: i.days.ago)
      end

      expect(controller).to receive(:authorize!).with(:read, CatEntry).once

      get :index
    end
    
    
    
  end
end