class MonthlyStatsCalculator
  def self.has_entries_last_30_days?
    return false if CatEntry.count_last_30_days == 0
    true
  end
  
  def self.count_resolved_last_30_days
    CatEntry.entries_last_30_days.select { |entry| entry.resolved == true }.count
  end

  def self.count_lost_last_30_days
    CatEntry.entries_last_30_days.where(entry_type: 'lost').count
  end
  
  def self.count_found_last_30_days
    CatEntry.entries_last_30_days.where(entry_type: 'found').count
  end
  
  def self.ratio_saved_last_30_days
    if self.has_entries_last_30_days?
       self.count_resolved_last_30_days.to_f / (self.count_found_last_30_days + self.count_lost_last_30_days)
    else
      0
    end
  end
end