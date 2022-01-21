# This is an autogenerated file for dynamic methods in Sources::FacebookUser
# Please rerun bundle exec rake rails_rbi:models[Sources::FacebookUser] to regenerate.

# typed: strong
module Sources::FacebookUser::ActiveRelation_WhereNot
  sig { params(opts: T.untyped, rest: T.untyped).returns(T.self_type) }
  def not(opts, *rest); end
end

module Sources::FacebookUser::GeneratedAttributeMethods
  sig { returns(ActiveSupport::TimeWithZone) }
  def created_at; end

  sig { params(value: T.any(Date, Time, ActiveSupport::TimeWithZone)).void }
  def created_at=(value); end

  sig { returns(T::Boolean) }
  def created_at?; end

  sig { returns(T.nilable(String)) }
  def facebook_id; end

  sig { params(value: T.nilable(T.any(String, Symbol))).void }
  def facebook_id=(value); end

  sig { returns(T::Boolean) }
  def facebook_id?; end

  sig { returns(T.nilable(Integer)) }
  def followers_count; end

  sig { params(value: T.nilable(T.any(Numeric, ActiveSupport::Duration))).void }
  def followers_count=(value); end

  sig { returns(T::Boolean) }
  def followers_count?; end

  sig { returns(String) }
  def id; end

  sig { params(value: T.any(String, Symbol)).void }
  def id=(value); end

  sig { returns(T::Boolean) }
  def id?; end

  sig { returns(T.nilable(Integer)) }
  def likes_count; end

  sig { params(value: T.nilable(T.any(Numeric, ActiveSupport::Duration))).void }
  def likes_count=(value); end

  sig { returns(T::Boolean) }
  def likes_count?; end

  sig { returns(T.nilable(String)) }
  def name; end

  sig { params(value: T.nilable(T.any(String, Symbol))).void }
  def name=(value); end

  sig { returns(T::Boolean) }
  def name?; end

  sig { returns(T.nilable(String)) }
  def profile; end

  sig { params(value: T.nilable(T.any(String, Symbol))).void }
  def profile=(value); end

  sig { returns(T::Boolean) }
  def profile?; end

  sig { returns(T.nilable(T.any(T::Array[T.untyped], T::Boolean, Float, T::Hash[T.untyped, T.untyped], Integer, String))) }
  def profile_image_data; end

  sig { params(value: T.nilable(T.any(T::Array[T.untyped], T::Boolean, Float, T::Hash[T.untyped, T.untyped], Integer, String))).void }
  def profile_image_data=(value); end

  sig { returns(T::Boolean) }
  def profile_image_data?; end

  sig { returns(T.nilable(String)) }
  def profile_image_url; end

  sig { params(value: T.nilable(T.any(String, Symbol))).void }
  def profile_image_url=(value); end

  sig { returns(T::Boolean) }
  def profile_image_url?; end

  sig { returns(ActiveSupport::TimeWithZone) }
  def updated_at; end

  sig { params(value: T.any(Date, Time, ActiveSupport::TimeWithZone)).void }
  def updated_at=(value); end

  sig { returns(T::Boolean) }
  def updated_at?; end

  sig { returns(T.nilable(String)) }
  def url; end

  sig { params(value: T.nilable(T.any(String, Symbol))).void }
  def url=(value); end

  sig { returns(T::Boolean) }
  def url?; end

  sig { returns(T.nilable(T::Boolean)) }
  def verified; end

  sig { params(value: T.nilable(T::Boolean)).void }
  def verified=(value); end

  sig { returns(T::Boolean) }
  def verified?; end
end

module Sources::FacebookUser::GeneratedAssociationMethods
  sig { returns(T.nilable(::ArchiveEntity)) }
  def archive_entity; end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::ArchiveEntity).void)).returns(::ArchiveEntity) }
  def build_archive_entity(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::ArchiveEntity).void)).returns(::ArchiveEntity) }
  def create_archive_entity(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::ArchiveEntity).void)).returns(::ArchiveEntity) }
  def create_archive_entity!(*args, &block); end

  sig { params(value: T.nilable(::ArchiveEntity)).void }
  def archive_entity=(value); end

  sig { returns(T.nilable(::ArchiveEntity)) }
  def reload_archive_entity; end

  sig { returns(::Sources::FacebookPost::ActiveRecord_Associations_CollectionProxy) }
  def facebook_posts; end

  sig { returns(T::Array[String]) }
  def facebook_post_ids; end

  sig { params(value: T::Enumerable[::Sources::FacebookPost]).void }
  def facebook_posts=(value); end

  sig { returns(T.nilable(T.untyped)) }
  def pg_search_document; end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: T.untyped).void)).returns(T.untyped) }
  def build_pg_search_document(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: T.untyped).void)).returns(T.untyped) }
  def create_pg_search_document(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: T.untyped).void)).returns(T.untyped) }
  def create_pg_search_document!(*args, &block); end

  sig { params(value: T.nilable(T.untyped)).void }
  def pg_search_document=(value); end

  sig { returns(T.nilable(T.untyped)) }
  def reload_pg_search_document; end
end

module Sources::FacebookUser::CustomFinderMethods
  sig { params(limit: Integer).returns(T::Array[Sources::FacebookUser]) }
  def first_n(limit); end

  sig { params(limit: Integer).returns(T::Array[Sources::FacebookUser]) }
  def last_n(limit); end

  sig { params(args: T::Array[T.any(Integer, String)]).returns(T::Array[Sources::FacebookUser]) }
  def find_n(*args); end

  sig { params(id: T.nilable(Integer)).returns(T.nilable(Sources::FacebookUser)) }
  def find_by_id(id); end

  sig { params(id: Integer).returns(Sources::FacebookUser) }
  def find_by_id!(id); end
end

class Sources::FacebookUser < ApplicationRecord
  include Sources::FacebookUser::GeneratedAttributeMethods
  include Sources::FacebookUser::GeneratedAssociationMethods
  extend Sources::FacebookUser::CustomFinderMethods
  extend Sources::FacebookUser::QueryMethodsReturningRelation
  RelationType = T.type_alias { T.any(Sources::FacebookUser::ActiveRecord_Relation, Sources::FacebookUser::ActiveRecord_Associations_CollectionProxy, Sources::FacebookUser::ActiveRecord_AssociationRelation) }
end

module Sources::FacebookUser::QueryMethodsReturningRelation
  sig { returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def reselect(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def extract_associated(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def optimizer_hints(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def except(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def only(*args); end

  sig { params(block: T.proc.params(e: Sources::FacebookUser).returns(T::Boolean)).returns(T::Array[Sources::FacebookUser]) }
  def select(&block); end

  sig { params(args: T.any(String, Symbol, T::Array[T.any(String, Symbol)])).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def select_columns(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def extending(*args, &block); end

  sig do
    params(
      of: T.nilable(Integer),
      start: T.nilable(Integer),
      finish: T.nilable(Integer),
      load: T.nilable(T::Boolean),
      error_on_ignore: T.nilable(T::Boolean),
      block: T.nilable(T.proc.params(e: Sources::FacebookUser::ActiveRecord_Relation).void)
    ).returns(ActiveRecord::Batches::BatchEnumerator)
  end
  def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, &block); end
end

module Sources::FacebookUser::QueryMethodsReturningAssociationRelation
  sig { returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(Sources::FacebookUser::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def reselect(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def extract_associated(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def optimizer_hints(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def except(*args); end

  sig { params(args: T.untyped).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def only(*args); end

  sig { params(block: T.proc.params(e: Sources::FacebookUser).returns(T::Boolean)).returns(T::Array[Sources::FacebookUser]) }
  def select(&block); end

  sig { params(args: T.any(String, Symbol, T::Array[T.any(String, Symbol)])).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def select_columns(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(Sources::FacebookUser::ActiveRecord_AssociationRelation) }
  def extending(*args, &block); end

  sig do
    params(
      of: T.nilable(Integer),
      start: T.nilable(Integer),
      finish: T.nilable(Integer),
      load: T.nilable(T::Boolean),
      error_on_ignore: T.nilable(T::Boolean),
      block: T.nilable(T.proc.params(e: Sources::FacebookUser::ActiveRecord_AssociationRelation).void)
    ).returns(ActiveRecord::Batches::BatchEnumerator)
  end
  def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, &block); end
end

class Sources::FacebookUser::ActiveRecord_Relation < ActiveRecord::Relation
  include Sources::FacebookUser::ActiveRelation_WhereNot
  include Sources::FacebookUser::CustomFinderMethods
  include Sources::FacebookUser::QueryMethodsReturningRelation
  Elem = type_member(fixed: Sources::FacebookUser)
end

class Sources::FacebookUser::ActiveRecord_AssociationRelation < ActiveRecord::AssociationRelation
  include Sources::FacebookUser::ActiveRelation_WhereNot
  include Sources::FacebookUser::CustomFinderMethods
  include Sources::FacebookUser::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: Sources::FacebookUser)
end

class Sources::FacebookUser::ActiveRecord_Associations_CollectionProxy < ActiveRecord::Associations::CollectionProxy
  include Sources::FacebookUser::CustomFinderMethods
  include Sources::FacebookUser::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: Sources::FacebookUser)

  sig { params(records: T.any(Sources::FacebookUser, T::Array[Sources::FacebookUser])).returns(T.self_type) }
  def <<(*records); end

  sig { params(records: T.any(Sources::FacebookUser, T::Array[Sources::FacebookUser])).returns(T.self_type) }
  def append(*records); end

  sig { params(records: T.any(Sources::FacebookUser, T::Array[Sources::FacebookUser])).returns(T.self_type) }
  def push(*records); end

  sig { params(records: T.any(Sources::FacebookUser, T::Array[Sources::FacebookUser])).returns(T.self_type) }
  def concat(*records); end
end
