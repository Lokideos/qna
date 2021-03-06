require 'rails_helper'

RSpec.describe User do
  context 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
  end

  context 'methods test' do
    it "author_of? method should return true" do
      user = create(:user)
      question = create(:question, user: user)
      expect(user.author_of?(question)).to eq true
    end

    describe '.find_for_oauth' do
      let!(:user) { create(:user) }      
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

      context 'user already has authorization' do
        it 'returns the user' do
          user.authorizations.create(provider: 'facebook', uid: '123456')
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user has not authorization' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        context 'user already exists' do
          it 'does not create new user' do
            expect { User.find_for_oauth(auth) }.to_not change(User, :count)
          end

          it 'creates new authorization user' do
            expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
          end

          it 'creates authorization with provider and uid' do
            authorization = User.find_for_oauth(auth).authorizations.first
            
            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it 'returns user' do
            expect(User.find_for_oauth(auth)).to eq user
          end
        end

        context 'user does not exist' do
          context 'oauth service provided email' do
            let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }
            it 'creates new user' do
              expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
            end

            it 'returns new user' do
              expect(User.find_for_oauth(auth)).to be_a(User)
            end

            it 'fills user email' do
              user = User.find_for_oauth(auth)
              expect(user.email).to eq auth.info[:email]
            end

            it 'creates authorization for user' do
              user = User.find_for_oauth(auth)
              expect(user.authorizations).to_not be_empty
            end

            it 'creates authorization with provider and uid' do
              authorization = User.find_for_oauth(auth).authorizations.first

              expect(authorization.provider).to eq auth.provider
              expect(authorization.uid).to eq auth.uid
            end
          end

          context 'oauth service did not provide email and user provided it by himself' do
            let(:auth_for_new_user) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '12345', info: { email: 'new@user.com', new_user: true }) }

            it 'creates new user' do
              expect { User.find_for_oauth(auth_for_new_user) }.to change(User, :count).by(1)
            end

            it 'returns new user' do
              expect(User.find_for_oauth(auth_for_new_user)).to be_a(User)
            end

            it 'fills user email' do
              user = User.find_for_oauth(auth_for_new_user)
              expect(user.email).to eq auth_for_new_user.info[:email]
            end

            it 'creates authorization for user' do
              user = User.find_for_oauth(auth_for_new_user)
              expect(user.authorizations).to_not be_empty
            end

            it 'creates authorization with provider and uid' do
              authorization = User.find_for_oauth(auth_for_new_user).authorizations.first

              expect(authorization.provider).to eq auth_for_new_user.provider
              expect(authorization.uid).to eq auth_for_new_user.uid
            end
          end
        end
      end

    end    
  
end

  context 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end
end
