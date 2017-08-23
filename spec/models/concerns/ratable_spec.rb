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

  it "#add_rating" do
    expect(WithRatable.create!.add_rating(user).value).to eq 1
  end

  it "decrease_rating" do
    expect(WithRatable.create!.decrease_rating(user).value).to eq -1
  end

  it "nullify_rating" do
    expect(WithRatable.create!.nullify_rating(user)).to eq nil
  end

  it "should have many ratings" do
    association = WithRatable.reflect_on_association(:ratings)
    expect(association.macro).to eq(:has_many)
  end
end
