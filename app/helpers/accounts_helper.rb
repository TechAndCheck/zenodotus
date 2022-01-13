module AccountsHelper
  # sig { params(search_records: TextSearch::ActiveRecordRelation}
  def split_searches_by_date(search_records)
    dated_searches = {}
    # dated_searches.default = []
    search_records.each do |record|
      stringified_date = record.created_at.strftime "%A, %B %e, %Y"
      dated_searches[stringified_date] = [] unless dated_searches.include?(stringified_date)
      dated_searches[stringified_date].append(record)
    end
    dated_searches
  end
end
