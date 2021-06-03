# typed: false
class ApplicationRecord < ActiveRecord::Base
  extend T::Sig
  extend T::Helpers

  self.abstract_class = true
end
