Fabricator(:merchant) do
  title    { Faker::Lorem.word }
  is_type  { Faker::Lorem.word }
  merchant { Faker::Lorem.word }
  metadata { { test: Faker::Lorem.paragraph }}
end

Fabricator(:payline_merchant, from: :merchant) do
  title                   'payline'
  is_type                 'payline'
  merchant                'payline'
  metadata                { {
    'username': 'Isweep631',
    'password': '4aCtPCLoYhbBFVVEymLuXcKq',
    'url':      'https://secure.paylinedatagateway.com/api/transact.php'
  }}
end
