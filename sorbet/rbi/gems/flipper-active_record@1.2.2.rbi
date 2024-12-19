# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `flipper-active_record` gem.
# Please instead update this file by running `bin/tapioca gem flipper-active_record`.


# source://flipper-active_record//lib/flipper/version.rb#1
module Flipper
  # source://forwardable/1.3.3/forwardable.rb#231
  def [](*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def adapter(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def add(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def add_expression(*args, **_arg1, &block); end

  # source://flipper/1.2.2/lib/flipper.rb#75
  def all(*args); end

  # source://flipper/1.2.2/lib/flipper.rb#71
  def any(*args); end

  # source://flipper/1.2.2/lib/flipper.rb#95
  def boolean(value); end

  # source://flipper/1.2.2/lib/flipper.rb#28
  def configuration; end

  # source://flipper/1.2.2/lib/flipper.rb#33
  def configuration=(configuration); end

  # source://flipper/1.2.2/lib/flipper.rb#23
  def configure; end

  # source://flipper/1.2.2/lib/flipper.rb#79
  def constant(value); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def disable(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def disable_actor(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def disable_expression(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def disable_group(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def disable_percentage_of_actors(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def disable_percentage_of_time(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def enable(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def enable_actor(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def enable_expression(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def enable_group(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def enable_percentage_of_actors(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def enable_percentage_of_time(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def enabled?(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def exist?(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def export(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def expression(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def feature(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def features(*args, **_arg1, &block); end

  # source://flipper/1.2.2/lib/flipper.rb#160
  def group(name); end

  # source://flipper/1.2.2/lib/flipper.rb#147
  def group_exists?(name); end

  # source://flipper/1.2.2/lib/flipper.rb#133
  def group_names; end

  # source://flipper/1.2.2/lib/flipper.rb#126
  def groups; end

  # source://flipper/1.2.2/lib/flipper.rb#165
  def groups_registry; end

  # source://flipper/1.2.2/lib/flipper.rb#170
  def groups_registry=(registry); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def import(*args, **_arg1, &block); end

  # source://flipper/1.2.2/lib/flipper.rb#45
  def instance; end

  # source://flipper/1.2.2/lib/flipper.rb#52
  def instance=(flipper); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def memoize=(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def memoizing?(*args, **_arg1, &block); end

  # source://flipper/1.2.2/lib/flipper.rb#12
  def new(adapter, options = T.unsafe(nil)); end

  # source://flipper/1.2.2/lib/flipper.rb#91
  def number(value); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def preload(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def preload_all(*args, **_arg1, &block); end

  # source://flipper/1.2.2/lib/flipper.rb#83
  def property(name); end

  # source://flipper/1.2.2/lib/flipper.rb#99
  def random(max); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def read_only?(*args, **_arg1, &block); end

  # source://flipper/1.2.2/lib/flipper.rb#117
  def register(name, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def remove(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def remove_expression(*args, **_arg1, &block); end

  # source://flipper/1.2.2/lib/flipper.rb#87
  def string(value); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def sync(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def sync_secret(*args, **_arg1, &block); end

  # source://flipper/1.2.2/lib/flipper.rb#140
  def unregister_groups; end

  class << self
    # @return [Boolean]
    #
    # source://flipper-active_record//lib/flipper/version.rb#10
    def deprecated_ruby_version?; end
  end
end

# source://flipper-active_record//lib/flipper/adapters/active_record.rb#6
module Flipper::Adapters; end

# source://flipper-active_record//lib/flipper/adapters/active_record.rb#7
class Flipper::Adapters::ActiveRecord
  include ::Flipper::Adapter
  extend ::Flipper::Adapter::ClassMethods

  # Public: Initialize a new ActiveRecord adapter instance.
  #
  # name - The Symbol name for this adapter. Optional (default :active_record)
  # feature_class - The AR class responsible for the features table.
  # gate_class - The AR class responsible for the gates table.
  #
  # Allowing the overriding of name is so you can differentiate multiple
  # instances of this adapter from each other, if, for some reason, that is
  # a thing you do.
  #
  # Allowing the overriding of the default feature/gate classes means you
  # can roll your own tables and what not, if you so desire.
  #
  # @return [ActiveRecord] a new instance of ActiveRecord
  #
  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#52
  def initialize(options = T.unsafe(nil)); end

  # Public: Adds a feature to the set of known features.
  #
  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#66
  def add(feature); end

  # Public: Clears the gate values for a feature.
  #
  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#95
  def clear(feature); end

  # Public: Disables a gate for a given thing.
  #
  # feature - The Flipper::Feature for the gate.
  # gate - The Flipper::Gate to disable.
  # thing - The Flipper::Type being disabled for the gate.
  #
  # Returns true.
  #
  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#183
  def disable(feature, gate, thing); end

  # Public: Enables a gate for a given thing.
  #
  # feature - The Flipper::Feature for the gate.
  # gate - The Flipper::Gate to enable.
  # thing - The Flipper::Type being enabled for the gate.
  #
  # Returns true.
  #
  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#159
  def enable(feature, gate, thing); end

  # Public: The set of known features.
  #
  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#61
  def features; end

  # Public: Gets the values for all gates for a given feature.
  #
  # Returns a Hash of Flipper::Gate#key => value.
  #
  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#103
  def get(feature); end

  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#125
  def get_all; end

  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#108
  def get_multi(features); end

  # Public: Removes a feature from the set of known features.
  #
  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#84
  def remove(feature); end

  # Private
  #
  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#203
  def unsupported_data_type(data_type); end

  private

  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#236
  def delete(feature, gate); end

  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#240
  def enable_multi(feature, gate, thing); end

  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#254
  def result_for_gates(feature, gates); end

  # @raise [VALUE_TO_TEXT_WARNING]
  #
  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#209
  def set(feature, gate, thing, options = T.unsafe(nil)); end

  # Check if value column is text instead of string
  # See https://github.com/flippercloud/flipper/pull/692
  #
  # @return [Boolean]
  #
  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#279
  def value_not_text?; end

  # source://flipper-active_record//lib/flipper/adapters/active_record.rb#286
  def with_connection(model = T.unsafe(nil), &block); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# Private: Do not use outside of this adapter.
#
# source://flipper-active_record//lib/flipper/adapters/active_record.rb#16
class Flipper::Adapters::ActiveRecord::Feature < ::Flipper::Adapters::ActiveRecord::Model
  include ::Flipper::Adapters::ActiveRecord::Feature::GeneratedAttributeMethods
  include ::Flipper::Adapters::ActiveRecord::Feature::GeneratedAssociationMethods

  # source://activerecord/7.2.2.1/lib/active_record/autosave_association.rb#162
  def autosave_associated_records_for_gates(*args); end

  # source://activerecord/7.2.2.1/lib/active_record/autosave_association.rb#162
  def validate_associated_records_for_gates(*args); end

  class << self
    # source://activesupport/7.2.2.1/lib/active_support/callbacks.rb#70
    def __callbacks; end

    # source://activerecord/7.2.2.1/lib/active_record/reflection.rb#11
    def _reflections; end

    # source://activemodel/7.2.2.1/lib/active_model/validations.rb#71
    def _validators; end

    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end

    # source://activerecord/7.2.2.1/lib/active_record/enum.rb#167
    def defined_enums; end
  end
end

# source://flipper-active_record//lib/flipper/adapters/active_record.rb#0
module Flipper::Adapters::ActiveRecord::Feature::GeneratedAssociationMethods
  # source://activerecord/7.2.2.1/lib/active_record/associations/builder/collection_association.rb#62
  def gate_ids; end

  # source://activerecord/7.2.2.1/lib/active_record/associations/builder/collection_association.rb#72
  def gate_ids=(ids); end

  # source://activerecord/7.2.2.1/lib/active_record/associations/builder/association.rb#103
  def gates; end

  # source://activerecord/7.2.2.1/lib/active_record/associations/builder/association.rb#111
  def gates=(value); end
end

# source://flipper-active_record//lib/flipper/adapters/active_record.rb#0
module Flipper::Adapters::ActiveRecord::Feature::GeneratedAttributeMethods; end

# Private: Do not use outside of this adapter.
#
# source://flipper-active_record//lib/flipper/adapters/active_record.rb#27
class Flipper::Adapters::ActiveRecord::Gate < ::Flipper::Adapters::ActiveRecord::Model
  include ::Flipper::Adapters::ActiveRecord::Gate::GeneratedAttributeMethods
  include ::Flipper::Adapters::ActiveRecord::Gate::GeneratedAssociationMethods

  class << self
    # source://activemodel/7.2.2.1/lib/active_model/validations.rb#71
    def _validators; end

    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end

    # source://activerecord/7.2.2.1/lib/active_record/enum.rb#167
    def defined_enums; end
  end
end

# source://flipper-active_record//lib/flipper/adapters/active_record.rb#0
module Flipper::Adapters::ActiveRecord::Gate::GeneratedAssociationMethods; end

# source://flipper-active_record//lib/flipper/adapters/active_record.rb#0
module Flipper::Adapters::ActiveRecord::Gate::GeneratedAttributeMethods; end

# Abstract base class for internal models
#
# source://flipper-active_record//lib/flipper/adapters/active_record.rb#11
class Flipper::Adapters::ActiveRecord::Model < ::ActiveRecord::Base
  include ::Flipper::Adapters::ActiveRecord::Model::GeneratedAttributeMethods
  include ::Flipper::Adapters::ActiveRecord::Model::GeneratedAssociationMethods

  class << self
    # source://activemodel/7.2.2.1/lib/active_model/validations.rb#71
    def _validators; end

    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end

    # source://activerecord/7.2.2.1/lib/active_record/enum.rb#167
    def defined_enums; end
  end
end

# source://flipper-active_record//lib/flipper/adapters/active_record.rb#0
module Flipper::Adapters::ActiveRecord::Model::GeneratedAssociationMethods; end

# source://flipper-active_record//lib/flipper/adapters/active_record.rb#0
module Flipper::Adapters::ActiveRecord::Model::GeneratedAttributeMethods; end

# source://flipper-active_record//lib/flipper/adapters/active_record.rb#35
Flipper::Adapters::ActiveRecord::VALUE_TO_TEXT_WARNING = T.let(T.unsafe(nil), String)

# source://flipper-active_record//lib/flipper/version.rb#8
Flipper::NEXT_REQUIRED_RAILS_VERSION = T.let(T.unsafe(nil), String)

# source://flipper-active_record//lib/flipper/version.rb#5
Flipper::NEXT_REQUIRED_RUBY_VERSION = T.let(T.unsafe(nil), String)

# source://flipper-active_record//lib/flipper/version.rb#7
Flipper::REQUIRED_RAILS_VERSION = T.let(T.unsafe(nil), String)

# source://flipper-active_record//lib/flipper/version.rb#4
Flipper::REQUIRED_RUBY_VERSION = T.let(T.unsafe(nil), String)

# source://flipper-active_record//lib/flipper/version.rb#2
Flipper::VERSION = T.let(T.unsafe(nil), String)
