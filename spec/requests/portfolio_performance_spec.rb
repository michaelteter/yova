require 'rails_helper'

RSpec.describe "PortfolioPerformances", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/portfolio_performances/show"
      expect(response).to have_http_status(:success)
    end
  end

end
