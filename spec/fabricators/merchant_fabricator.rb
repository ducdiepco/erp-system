Fabricator(:merchant) do
  title    { Faker::Lorem.word }
  is_type     { Faker::Lorem.word }
  metadata { { test: Faker::Lorem.paragraph }}
end
