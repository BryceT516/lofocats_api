require 'spec_helper'

describe MonthlyStatsCalculator do
  describe '#has_entries_last_30_days' do
    context 'there are no entries in the last 30 days' do
      it 'returns false' do
        expect(described_class.has_entries_last_30_days?).to be_falsy
      end
    end
  end  
  context 'there are entries in the last 30 days' do
    context 'there is one lost entry' do
      before do
        FactoryGirl.create(:cat_entry,
                            :breed => "Breed", 
                            :user => FactoryGirl.create(:user,
                              :email => "user1@lofocats.com"),
                            :entry_type => 'lost',
                            :event_date => 10.days.ago,
                            :created_at => 10.days.ago)
      end
      
      it 'reports the correct number of lost entries' do
        expect(described_class.count_lost_last_30_days).to eq(1)
      end
      
      context 'there is one found entry' do
        before do
          FactoryGirl.create(:cat_entry,
                            :breed => "Breed", 
                            :user => FactoryGirl.create(:user,
                              :email => "user2@lofocats.com"),
                            :entry_type => 'found',
                            :event_date => 10.days.ago,
                            :created_at => 10.days.ago)
        end
        
        it 'reports the correct number of found entries' do
          expect(described_class.count_found_last_30_days).to eq(1)
        end
        context 'and both entries are resolved' do
          before do
            CatEntry.update_all(resolved: true)
          end
          it 'reports the correct number of resolved entries' do
            expect(described_class.count_resolved_last_30_days).to eq(2)
          end
          it 'reports the correct ratio of saves' do
            expect(described_class.ratio_saved_last_30_days).to eq(1)
          end
        end
        
        context 'and the found entry is resolved' do
          before do
            CatEntry.find_by(entry_type: 'found').update_attributes(resolved: true)
          end
          it 'reports the correct number of resolved entries' do
            expect(described_class.count_resolved_last_30_days).to eq(1)
          end
          it 'reports the correct ratio of saves' do
            expect(described_class.ratio_saved_last_30_days).to eq(0.5)
          end
        end
        
        context 'and neither entry is resolved' do
          it 'reports the correct number of resolved entries' do
            expect(described_class.count_resolved_last_30_days).to eq(0)
          end
          it 'reports the correct ratio of saves' do
            expect(described_class.ratio_saved_last_30_days).to eq(0)
          end
        end
      end
      
      context 'there are no found entries' do
        context 'and the lost entry is resolved' do
          before do
            CatEntry.find_by(entry_type: 'lost').update_attributes(resolved: true)
          end
          it 'reports the correct number of resolved entries' do
            expect(described_class.count_resolved_last_30_days).to eq(1)
          end
          it 'reports the correct ratio of saves' do
            expect(described_class.ratio_saved_last_30_days).to eq(1)
          end
        end
        
        context 'and the lost entry is not resolved' do
          it 'reports the correct number of resolved entries' do
            expect(described_class.ratio_saved_last_30_days).to eq(0)
          end
          it 'reports the correct ratio of saves' do
            expect(described_class.ratio_saved_last_30_days).to eq(0)
          end
        end
      end
    end
    
    context 'there are zero lost entries' do
      context 'there is one found entry' do
        before do
          FactoryGirl.create(:cat_entry,
                            :breed => "Breed", 
                            :user => FactoryGirl.create(:user,
                              :email => "user3@lofocats.com"),
                            :entry_type => 'found',
                            :event_date => 10.days.ago,
                            :created_at => 10.days.ago)
        end
        
        context 'and the found entry is resolved' do
          before do
            CatEntry.last.update_attributes(:resolved => true)
          end
          it 'reports the correct resolved count' do
            expect(described_class.count_resolved_last_30_days).to eq(1)
          end
          it 'reports the correct saved ratio' do
            expect(described_class.ratio_saved_last_30_days).to eq(1)
          end
        end
        context 'and the found entry is not resolved' do
          it 'reports the correct resolved count' do
            expect(described_class.count_resolved_last_30_days).to eq(0)
          end
          it 'reports the correct resolved count' do
            expect(described_class.ratio_saved_last_30_days).to eq(0)
          end
        end
      end
    end
  end
end
