return if AssetPerformance.count > 0

puts '... this will take 1-2 minutes ...'
PerformanceCalcService.calc_all_returns_for_all_assets
