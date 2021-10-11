# typed: strict
module ApplicationHelper
  def prune_archive_items(relation)
    relation.to_json(only: [:id, :created_at],
                     include: [ { media_review: { except: [:id, :created_at, :updated_at, :archive_item_id] } },
                                { archivable_item: { include: { author: { only: [:handle, :display_name, :twitter_id] } },
                                                     except: [:language, :author_id, :id] }
                                }])
  end
end
