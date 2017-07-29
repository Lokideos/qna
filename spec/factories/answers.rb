FactoryGirl.define do
  factory :answer do
    body "MyText"
    question
    user_id { create(:user).id }
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    question
    user_id { create(:user).id }
  end
end
