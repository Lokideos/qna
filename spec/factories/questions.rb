FactoryGirl.define do
  sequence :title do |n|
    "Test Question#{n}"
  end

  factory :question do
    title
    body "MyQuestionText"
    user

    factory :invalid_question do
      title nil
      body nil
    end
  end

end
