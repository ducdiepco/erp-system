class Merchant < Hanami::Entity
  attributes do
    attribute :id,       Types::Int
    attribute :title,    Types::String
    attribute :is_type,  Types::String
    attribute :merchant, Types::String
    attribute :metadata, Types::String
  end
end
