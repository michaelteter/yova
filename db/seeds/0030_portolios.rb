require 'set'

client_ids = Client.all.pluck(:id)
company_ids = Company.all.pluck(:id)

PORTFOLIO_SIZE = 40
WEIGHT = 2.5

client_ids.each do |client_id|
  next if Portfolio.exists?(client_id: client_id)

  selected_company_ids_indices = Util.distinct_rand_ints(n_ints: PORTFOLIO_SIZE, max_int: company_ids.length - 1)

  Portfolio.transaction do
    selected_company_ids_indices.sort.each do |company_id_index|
      Portfolio.create(client_id: client_id,
                       company_id: company_ids[company_id_index],
                       weight: WEIGHT)
    end
  end
end
