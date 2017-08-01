FactoryGirl.define do
  sequence :title do |n|
    "Test Question#{n}"
  end

  factory :question do
    title
    body "MyQuestionText"
    user
  end

  factory :question_without_user do
    title
    body "Question Without User"
  end


  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end
end
