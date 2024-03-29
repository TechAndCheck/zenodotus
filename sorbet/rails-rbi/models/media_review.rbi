# This is an autogenerated file for dynamic methods in MediaReview
# Please rerun bundle exec rake rails_rbi:models[MediaReview] to regenerate.

# typed: strong
module MediaReview::ActiveRelation_WhereNot
  sig { params(opts: T.untyped, rest: T.untyped).returns(T.self_type) }
  def not(opts, *rest); end
end

module MediaReview::GeneratedAttributeMethods
  sig { returns(String) }
  def archive_item_id; end

  sig { params(value: T.any(String, Symbol)).void }
  def archive_item_id=(value); end

  sig { returns(T::Boolean) }
  def archive_item_id?; end

  sig { returns(ActiveSupport::TimeWithZone) }
  def created_at; end

  sig { params(value: T.any(Date, Time, ActiveSupport::TimeWithZone)).void }
  def created_at=(value); end

  sig { returns(T::Boolean) }
  def created_at?; end

  sig { returns(String) }
  def id; end

  sig { params(value: T.any(String, Symbol)).void }
  def id=(value); end

  sig { returns(T::Boolean) }
  def id?; end

  sig { returns(String) }
  def media_authenticity_category; end

  sig { params(value: T.any(String, Symbol)).void }
  def media_authenticity_category=(value); end

  sig { returns(T::Boolean) }
  def media_authenticity_category?; end

  sig { returns(String) }
  def original_media_context_description; end

  sig { params(value: T.any(String, Symbol)).void }
  def original_media_context_description=(value); end

  sig { returns(T::Boolean) }
  def original_media_context_description?; end

  sig { returns(String) }
  def original_media_link; end

  sig { params(value: T.any(String, Symbol)).void }
  def original_media_link=(value); end

  sig { returns(T::Boolean) }
  def original_media_link?; end

  sig { returns(ActiveSupport::TimeWithZone) }
  def updated_at; end

  sig { params(value: T.any(Date, Time, ActiveSupport::TimeWithZone)).void }
  def updated_at=(value); end

  sig { returns(T::Boolean) }
  def updated_at?; end
end

module MediaReview::GeneratedAssociationMethods
  sig { returns(::ArchiveItem) }
  def archive_item; end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::ArchiveItem).void)).returns(::ArchiveItem) }
  def build_archive_item(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::ArchiveItem).void)).returns(::ArchiveItem) }
  def create_archive_item(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::ArchiveItem).void)).returns(::ArchiveItem) }
  def create_archive_item!(*args, &block); end

  sig { params(value: ::ArchiveItem).void }
  def archive_item=(value); end

  sig { returns(::ArchiveItem) }
  def reload_archive_item; end
end

module MediaReview::CustomFinderMethods
  sig { params(limit: Integer).returns(T::Array[MediaReview]) }
  def first_n(limit); end

  sig { params(limit: Integer).returns(T::Array[MediaReview]) }
  def last_n(limit); end

  sig { params(args: T::Array[T.any(Integer, String)]).returns(T::Array[MediaReview]) }
  def find_n(*args); end

  sig { params(id: T.nilable(Integer)).returns(T.nilable(MediaReview)) }
  def find_by_id(id); end

  sig { params(id: Integer).returns(MediaReview) }
  def find_by_id!(id); end
end

class MediaReview < ApplicationRecord
  include MediaReview::GeneratedAttributeMethods
  include MediaReview::GeneratedAssociationMethods
  extend MediaReview::CustomFinderMethods
  extend MediaReview::QueryMethodsReturningRelation
  RelationType = T.type_alias { T.any(MediaReview::ActiveRecord_Relation, MediaReview::ActiveRecord_Associations_CollectionProxy, MediaReview::ActiveRecord_AssociationRelation) }
end

module MediaReview::QueryMethodsReturningRelation
  sig { returns(MediaReview::ActiveRecord_Relation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(MediaReview::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def reselect(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def extract_associated(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def optimizer_hints(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def except(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_Relation) }
  def only(*args); end

  sig { params(block: T.proc.params(e: MediaReview).returns(T::Boolean)).returns(T::Array[MediaReview]) }
  def select(&block); end

  sig { params(args: T.any(String, Symbol, T::Array[T.any(String, Symbol)])).returns(MediaReview::ActiveRecord_Relation) }
  def select_columns(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(MediaReview::ActiveRecord_Relation) }
  def extending(*args, &block); end

  sig do
    params(
      of: T.nilable(Integer),
      start: T.nilable(Integer),
      finish: T.nilable(Integer),
      load: T.nilable(T::Boolean),
      error_on_ignore: T.nilable(T::Boolean),
      block: T.nilable(T.proc.params(e: MediaReview::ActiveRecord_Relation).void)
    ).returns(ActiveRecord::Batches::BatchEnumerator)
  end
  def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, &block); end
end

module MediaReview::QueryMethodsReturningAssociationRelation
  sig { returns(MediaReview::ActiveRecord_AssociationRelation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(MediaReview::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def reselect(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def extract_associated(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def optimizer_hints(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def except(*args); end

  sig { params(args: T.untyped).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def only(*args); end

  sig { params(block: T.proc.params(e: MediaReview).returns(T::Boolean)).returns(T::Array[MediaReview]) }
  def select(&block); end

  sig { params(args: T.any(String, Symbol, T::Array[T.any(String, Symbol)])).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def select_columns(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(MediaReview::ActiveRecord_AssociationRelation) }
  def extending(*args, &block); end

  sig do
    params(
      of: T.nilable(Integer),
      start: T.nilable(Integer),
      finish: T.nilable(Integer),
      load: T.nilable(T::Boolean),
      error_on_ignore: T.nilable(T::Boolean),
      block: T.nilable(T.proc.params(e: MediaReview::ActiveRecord_AssociationRelation).void)
    ).returns(ActiveRecord::Batches::BatchEnumerator)
  end
  def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, &block); end
end

class MediaReview::ActiveRecord_Relation < ActiveRecord::Relation
  include MediaReview::ActiveRelation_WhereNot
  include MediaReview::CustomFinderMethods
  include MediaReview::QueryMethodsReturningRelation
  Elem = type_member(fixed: MediaReview)
end

class MediaReview::ActiveRecord_AssociationRelation < ActiveRecord::AssociationRelation
  include MediaReview::ActiveRelation_WhereNot
  include MediaReview::CustomFinderMethods
  include MediaReview::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: MediaReview)
end

class MediaReview::ActiveRecord_Associations_CollectionProxy < ActiveRecord::Associations::CollectionProxy
  include MediaReview::CustomFinderMethods
  include MediaReview::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: MediaReview)

  sig { params(records: T.any(MediaReview, T::Array[MediaReview])).returns(T.self_type) }
  def <<(*records); end

  sig { params(records: T.any(MediaReview, T::Array[MediaReview])).returns(T.self_type) }
  def append(*records); end

  sig { params(records: T.any(MediaReview, T::Array[MediaReview])).returns(T.self_type) }
  def push(*records); end

  sig { params(records: T.any(MediaReview, T::Array[MediaReview])).returns(T.self_type) }
  def concat(*records); end
end
