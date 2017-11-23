# application_record model (super class for applicaion's models)
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
