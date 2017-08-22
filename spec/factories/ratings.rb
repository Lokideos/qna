FactoryGirl.define do
  factory :rating do
    rating = 1
    user
    ratable nil

    factory :bad_rating do
      rating = -1
      user
      ratable nil
    end
  end
end
