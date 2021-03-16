class Portfolio < ApplicationRecord
  belongs_to :client
  belongs_to :company

  def self.client_portfolio_company_ids(client_id:)
    self.where(client_id: client_id).pluck(:company_id)
  end
end
