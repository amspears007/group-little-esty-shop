FactoryBot.define do
  factory :bulk_discount do
    threshold_quantity {Faker::Number.within(range: 50..500)}
    percentage {Faker::Number.within(range: 5..50)}
  end
end
