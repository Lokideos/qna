shared_examples_for "API Authenticalble" do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(access_token: '1234')
      expect(response.status).to eq 401
    end
  end

  context 'authorized' do
    let(:access_token_for_200_code) { create(:access_token) }

    it 'returns 200 status code' do
      do_request(access_token: access_token_for_200_code.token)
      expect(response).to be_success
    end
  end
end
