module Api
  module V1
    class PortfoliosController < ApplicationController
      def show
        client = Client.find_by(params[:uuid])
        render json: nil, status: 404 and return unless client

        pperfs ||= PerformanceCalcService.current_portfolio_performance(client_id: client.id)

        companies = client.companies.pluck(%i[symbol name])

        render json: { portfolio_performance: pperfs, portfolio_assets: companies }
      end
    end
  end
end
