class Movie < ApplicationRecord
  serialize :name_translations, Array
  serialize :overview_translations, Array
  serialize :aliases, Array
end
