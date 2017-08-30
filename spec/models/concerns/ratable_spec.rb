require 'rails_helper'
describe 'ratable' do
  with_model :WithRatable do
    table do |t|
      
    end

    model do
      include Ratable
    end
  end

  let(:user) { create(:user) }

  it "#add_rating if rating exists" do
    rating = WithRatable.create!.add_rating(user)
    expect(rating.user).to eq user
    expect(rating.value).to eq 1
  end

  it "#add_rating if rating doesn't exist" do
    ratable_object = WithRatable.create!
    ratable_object.decrease_rating(user)
    ratable_object.add_rating(user)
    expect(ratable_object.ratings.first.user).to eq user
    expect(ratable_object.ratings.first.value).to eq 1
  end

  it "decrease_rating if rating exists" do
    rating = WithRatable.create!.decrease_rating(user)
    expect(rating.user).to eq user
    expect(rating.value).to eq -1
  end

  it "decrease_rating if rating doesn't existt" do
    ratable_object = WithRatable.create!
    ratable_object.add_rating(user)
    ratable_object.decrease_rating(user)
    expect(ratable_object.ratings.first.user).to eq user
    expect(ratable_object.ratings.first.value).to eq -1
  end

  it "#nullify_rating" do
    ratable_object = WithRatable.create!
    ratable_object.add_rating(user)
    ratable_object.nullify_rating(user)
    expect(ratable_object.ratings.first).to eq nil
  end

  it "should have many ratings" do
    association = WithRatable.reflect_on_association(:ratings)
    expect(association.macro).to eq(:has_many)
  end
end
