FactoryBot.define do
  factory :borrow do
    user
    book
    borrowed_at { Time.current }
    due_date { 2.weeks.from_now }
    returned_at { nil }
  end
end
