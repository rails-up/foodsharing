namespace :geo do
  desc "Get Moscow subway stations from HeadHunter API"
  task moscow: :environment do
    require 'net/http'
    require 'json'
    s_name, s_lat, s_lng, l_name = ''
    city = City.find_or_create_by(name: 'Москва')

    puts 'Getting Moscow data from metro API...'
    uri = URI('https://api.hh.ru/metro/1')
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    data['lines'].each do |line|
      l_name = line['name']
      line['stations'].each do |station|
        s_name = station['name']
        s_lat =  station['lat']
        s_lng =  station['lng']
        Place.find_or_create_by!(name: s_name, lat: s_lat, lng: s_lng,
                                 line: l_name, city_id: city.id)
      end
    end
    puts 'Done'
  end

  desc "Get Saint Petersburg subway stations from HeadHunter API"
  task sp: :environment do
    require 'net/http'
    require 'json'
    s_name, s_lat, s_lng, l_name = ''
    city = City.find_or_create_by(name: 'Санкт-Петербург')

    puts 'Getting SP data from metro API...'
    uri = URI('https://api.hh.ru/metro/2')
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    data['lines'].each do |line|
      l_name = line['name']
      line['stations'].each do |station|
        s_name = station['name']
        s_lat =  station['lat']
        s_lng =  station['lng']
        Place.find_or_create_by!(name: s_name, lat: s_lat, lng: s_lng,
                                 line: l_name, city_id: city.id)
      end
    end
    puts 'Done'
  end

  task all: [:moscow, :sp]
end
