Dir[Rails.root.join('db/seeds/*.rb')].sort.each do |file|
  puts "Seeding #{file}"
  require file
end
