require 'rails_helper'

RSpec.describe NotifyAuthorJob, type: :job do
  let(:answer) { create(:answer) }

  it 'sends notification' do
    expect(Answer).to receive(:send_notification_to_subscribers)
    NotifyAuthorJob.perform_now(answer: answer)
  end
end
