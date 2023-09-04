class CacheEntry < ApplicationRecord
  validates :query, presence: true
  validates :page, presence: true, numericality: true
  validates :total_pages, presence: true, numericality: true
  validates :movies, presence: true
  validates :hit_count, presence: true, numericality: true
  validates :expires_at, presence: true

  def is_valid?
    expires_at.after?(Time.current)
  end

  def save_with_counter_reset!(attributes)
    self.attributes = attributes
    self.hit_count = 0
    self.expires_at = Time.current + CACHE_DURATION
    save!
  end
end
