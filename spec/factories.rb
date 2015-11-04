FactoryGirl.define do
  factory :customer do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
  end
end

FactoryGirl.define do
  factory :merchant do
    name {Faker::Company.name}
  end
end

FactoryGirl.define do
  factory :invoice do
    customer
    merchant
    status "shipped"
  end
end

FactoryGirl.define do
  factory :item do
    name {Faker::Commerce.product_name}
    description {Faker::Lorem.sentence(3)}
    unit_price {Random.rand(100..10000).to_f / 100}
    merchant
  end
end

FactoryGirl.define do
  factory :transaction do
    invoice
    credit_card_number {Faker::Business.credit_card_number}
    result ["success", "failed"].sample
  end
end

FactoryGirl.define do
  factory :invoice_item do
    item
    invoice
    quantity {Random.rand(1..10)}
    unit_price {Random.rand(100..10000).to_f / 100}
  end
end
