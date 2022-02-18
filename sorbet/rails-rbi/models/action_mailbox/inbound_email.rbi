# This is an autogenerated file for dynamic methods in ActionMailbox::InboundEmail
# Please rerun bundle exec rake rails_rbi:models[ActionMailbox::InboundEmail] to regenerate.

# typed: strong
module ActionMailbox::InboundEmail::EnumInstanceMethods
end

module ActionMailbox::InboundEmail::ActiveRelation_WhereNot
  sig { params(opts: T.untyped, rest: T.untyped).returns(T.self_type) }
  def not(opts, *rest); end
end

module ActionMailbox::InboundEmail::CustomFinderMethods
  sig { params(limit: Integer).returns(T::Array[ActionMailbox::InboundEmail]) }
  def first_n(limit); end

  sig { params(limit: Integer).returns(T::Array[ActionMailbox::InboundEmail]) }
  def last_n(limit); end

  sig { params(args: T::Array[T.any(Integer, String)]).returns(T::Array[ActionMailbox::InboundEmail]) }
  def find_n(*args); end

  sig { params(id: T.nilable(Integer)).returns(T.nilable(ActionMailbox::InboundEmail)) }
  def find_by_id(id); end

  sig { params(id: Integer).returns(ActionMailbox::InboundEmail) }
  def find_by_id!(id); end
end

class ActionMailbox::InboundEmail < ActionMailbox::Record
  include ActionMailbox::InboundEmail::EnumInstanceMethods
  include ActionMailbox::InboundEmail::GeneratedAssociationMethods
  extend ActionMailbox::InboundEmail::CustomFinderMethods
  extend ActionMailbox::InboundEmail::QueryMethodsReturningRelation
  RelationType = T.type_alias { T.any(ActionMailbox::InboundEmail::ActiveRecord_Relation, ActionMailbox::InboundEmail::ActiveRecord_Associations_CollectionProxy, ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }

  sig { returns(T::Hash[T.any(String, Symbol), T.any()]) }
  def self.{:status=>[:pending, :processing, :delivered, :failed, :bounced]}s; end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def self.with_attached_raw_email(*args); end
end

class ActionMailbox::InboundEmail::ActiveRecord_Relation < ActiveRecord::Relation
  include ActionMailbox::InboundEmail::ActiveRelation_WhereNot
  include ActionMailbox::InboundEmail::CustomFinderMethods
  include ActionMailbox::InboundEmail::QueryMethodsReturningRelation
  Elem = type_member(fixed: ActionMailbox::InboundEmail)

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def with_attached_raw_email(*args); end
end

class ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation < ActiveRecord::AssociationRelation
  include ActionMailbox::InboundEmail::ActiveRelation_WhereNot
  include ActionMailbox::InboundEmail::CustomFinderMethods
  include ActionMailbox::InboundEmail::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: ActionMailbox::InboundEmail)

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def with_attached_raw_email(*args); end
end

class ActionMailbox::InboundEmail::ActiveRecord_Associations_CollectionProxy < ActiveRecord::Associations::CollectionProxy
  include ActionMailbox::InboundEmail::CustomFinderMethods
  include ActionMailbox::InboundEmail::QueryMethodsReturningAssociationRelation
  Elem = type_member(fixed: ActionMailbox::InboundEmail)

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def with_attached_raw_email(*args); end

  sig { params(records: T.any(ActionMailbox::InboundEmail, T::Array[ActionMailbox::InboundEmail])).returns(T.self_type) }
  def <<(*records); end

  sig { params(records: T.any(ActionMailbox::InboundEmail, T::Array[ActionMailbox::InboundEmail])).returns(T.self_type) }
  def append(*records); end

  sig { params(records: T.any(ActionMailbox::InboundEmail, T::Array[ActionMailbox::InboundEmail])).returns(T.self_type) }
  def push(*records); end

  sig { params(records: T.any(ActionMailbox::InboundEmail, T::Array[ActionMailbox::InboundEmail])).returns(T.self_type) }
  def concat(*records); end
end

module ActionMailbox::InboundEmail::QueryMethodsReturningRelation
  sig { returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def reselect(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def extract_associated(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def optimizer_hints(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def except(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def only(*args); end

  sig { params(block: T.proc.params(e: ActionMailbox::InboundEmail).returns(T::Boolean)).returns(T::Array[ActionMailbox::InboundEmail]) }
  def select(&block); end

  sig { params(args: T.any(String, Symbol, T::Array[T.any(String, Symbol)])).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def select_columns(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def extending(*args, &block); end

  sig do
    params(
      of: T.nilable(Integer),
      start: T.nilable(Integer),
      finish: T.nilable(Integer),
      load: T.nilable(T::Boolean),
      error_on_ignore: T.nilable(T::Boolean),
      block: T.nilable(T.proc.params(e: ActionMailbox::InboundEmail::ActiveRecord_Relation).void)
    ).returns(ActiveRecord::Batches::BatchEnumerator)
  end
  def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, &block); end
end

module ActionMailbox::InboundEmail::QueryMethodsReturningAssociationRelation
  sig { returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def all; end

  sig { params(block: T.nilable(T.proc.void)).returns(ActionMailbox::InboundEmail::ActiveRecord_Relation) }
  def unscoped(&block); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def reselect(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def order(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def reorder(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def group(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def limit(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def offset(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def joins(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def left_joins(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def left_outer_joins(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def where(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def rewhere(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def preload(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def extract_associated(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def eager_load(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def includes(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def from(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def lock(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def readonly(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def or(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def having(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def create_with(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def distinct(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def references(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def none(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def unscope(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def optimizer_hints(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def merge(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def except(*args); end

  sig { params(args: T.untyped).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def only(*args); end

  sig { params(block: T.proc.params(e: ActionMailbox::InboundEmail).returns(T::Boolean)).returns(T::Array[ActionMailbox::InboundEmail]) }
  def select(&block); end

  sig { params(args: T.any(String, Symbol, T::Array[T.any(String, Symbol)])).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def select_columns(*args); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.void)).returns(ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation) }
  def extending(*args, &block); end

  sig do
    params(
      of: T.nilable(Integer),
      start: T.nilable(Integer),
      finish: T.nilable(Integer),
      load: T.nilable(T::Boolean),
      error_on_ignore: T.nilable(T::Boolean),
      block: T.nilable(T.proc.params(e: ActionMailbox::InboundEmail::ActiveRecord_AssociationRelation).void)
    ).returns(ActiveRecord::Batches::BatchEnumerator)
  end
  def in_batches(of: 1000, start: nil, finish: nil, load: false, error_on_ignore: nil, &block); end
end

module ActionMailbox::InboundEmail::GeneratedAssociationMethods
  sig { returns(T.nilable(::ActiveStorage::Attachment)) }
  def raw_email_attachment; end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::ActiveStorage::Attachment).void)).returns(::ActiveStorage::Attachment) }
  def build_raw_email_attachment(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::ActiveStorage::Attachment).void)).returns(::ActiveStorage::Attachment) }
  def create_raw_email_attachment(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::ActiveStorage::Attachment).void)).returns(::ActiveStorage::Attachment) }
  def create_raw_email_attachment!(*args, &block); end

  sig { params(value: T.nilable(::ActiveStorage::Attachment)).void }
  def raw_email_attachment=(value); end

  sig { returns(T.nilable(::ActiveStorage::Attachment)) }
  def reload_raw_email_attachment; end

  sig { returns(T.nilable(::ActiveStorage::Blob)) }
  def raw_email_blob; end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::ActiveStorage::Blob).void)).returns(::ActiveStorage::Blob) }
  def build_raw_email_blob(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::ActiveStorage::Blob).void)).returns(::ActiveStorage::Blob) }
  def create_raw_email_blob(*args, &block); end

  sig { params(args: T.untyped, block: T.nilable(T.proc.params(object: ::ActiveStorage::Blob).void)).returns(::ActiveStorage::Blob) }
  def create_raw_email_blob!(*args, &block); end

  sig { params(value: T.nilable(::ActiveStorage::Blob)).void }
  def raw_email_blob=(value); end

  sig { returns(T.nilable(::ActiveStorage::Blob)) }
  def reload_raw_email_blob; end

  sig { returns(T.nilable(ActiveStorage::Attached::One)) }
  def raw_email; end

  sig { params(attachable: T.untyped).returns(T.untyped) }
  def raw_email=(attachable); end
end
