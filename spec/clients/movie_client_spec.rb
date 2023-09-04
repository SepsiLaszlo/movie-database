require 'rails_helper'

[MoviesClient, MoviesClientWithRailsCache].each do |described_class|
  RSpec.describe described_class do
    before do
      allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache.lookup_store(:memory_store))
      Rails.cache.clear
    end

    subject(:search_movies) { described_class.search(query:, page:) }

    let(:query) { 'test' }
    let(:page) { 1 }

    it 'has the correct attributes' do
      Timecop.freeze do
        expect(search_movies).to have_attributes(query:, page:, total_pages: be_a_kind_of(Numeric), hit_count: 0, expires_at: Time.current + 2.minutes,
                                                 movies: be_a_kind_of(Array))
      end
    end

    context 'when the query is nil' do
      let(:query) { nil }

      it 'results should have all the attributes' do
        Timecop.freeze do
          expect(search_movies).to have_attributes(query:, page:, total_pages: be_a_kind_of(Numeric), hit_count: 0, expires_at: Time.current,
                                                   movies: be_a_kind_of(Array))

        end
      end
    end

    context 'when the cache entry already present ' do
      before { described_class.search(query:, page:) }

      it 'increments the hit_count' do
        expect(search_movies.hit_count).to eq 1
      end

      context 'after the cache duration is ended' do
        before { Timecop.travel(2.minutes) }

        it 'resets the cache hit count' do
          expect(search_movies.hit_count).to eq 0
        end
      end
    end
  end
end