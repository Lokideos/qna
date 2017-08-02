require 'rails_helper'

RSpec.describe User do
  context 'associations' do
    it { should have_many :answers }
    it { should have_many :questions }
  end

  context 'methods test' do
    it "author_of? method should return true" do
      user = create(:user)
      question = create(:question, user: user)
      expect(user.author_of?(question)).to eq true
    end

  end

  context 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end
end
