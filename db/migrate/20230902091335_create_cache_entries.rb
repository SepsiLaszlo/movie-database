class CreateCacheEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :cache_entries do |t|
      t.string :query
      t.integer :page
      t.integer :total_pages
      t.json :movies
      t.timestamp :expires_at
      t.integer :hit_count
      t.index [:query, :page], unique: true

      t.timestamps
    end
  end
end
