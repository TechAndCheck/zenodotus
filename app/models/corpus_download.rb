class CorpusDownload < ApplicationRecord
  enum download_type: [:csv, :json]

  belongs_to :user
end
