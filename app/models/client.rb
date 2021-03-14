class Client < ApplicationRecord
  has_many :portfolio_entries, class_name: 'Portfolio'
  has_many :companies, through: :portfolio_entries
end
