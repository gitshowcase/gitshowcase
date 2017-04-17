require 'rails_helper'

RSpec.describe GithubUserService, type: :service do
  subject(:service) { GithubUserService.new(user) }

  let(:user) { FactoryGirl.create(:user) }
  let(:auth_data) {
    double(
        info: double(
            email: 'email'
        ),
        uid: 'uid',
        credentials: double(
            token: 'token'
        )
    )
  }

  describe '#auth' do
    it 'changes attributes' do
      expect { service.auth(auth_data) }.to change(user, :email).to('email').and \
        change(user, :password).and \
        change(user, :github_uid).to('uid').and \
        change(user, :github_token).to('token').and \
        change(user, :role).to('Jedi Developer')

      expect(user.password).not_to be_empty
      expect(user.persisted?).to be_truthy
    end
  end

  describe '#reauth' do
    it 'changes attributes' do
      expect { service.reauth(auth_data) }.to change(user, :github_token).to eq('token')
    end
  end

  describe '#sync' do
    context 'without github' do
      after :each do
        exception = "User ##{user.id} does not have github properties"
        expect { service.sync }.to raise_exception(exception)
      end

      it 'raises without github_uid' do
        user.github_uid = nil
        user.github_token = 'token'
      end

      it 'raises without github_token' do
        user.github_uid = 'uid'
        user.github_token = nil
      end
    end

    context 'with github' do
      let(:user) { FactoryGirl.create(:user, github_uid: 'uid', github_token: 'token') }

      it 'changes attributes' do
        github_user = double(
            name: 'John Doe',
            login: 'johndoe',
            avatar_url: 'https://avatars.githubusercontent.com/u/0',
            blog: 'johndoe.com',
            location: 'Brazil',
            email: 'contact@johndoe.com',
            bio: 'Lorem ipsum',
            company: '@company',
            hireable: true
        )

        allow(service).to receive(:client_user).and_return github_user

        expect { service.sync }.to change(user, :username).to('johndoe').and \
          change(user, :name).to('John Doe').and \
          change(user, :avatar).to('https://avatars.githubusercontent.com/u/0?s=400').and \
          change(user, :website).to('johndoe.com').and \
          change(user, :location).to('Brazil').and \
          change(user, :display_email).to('contact@johndoe.com').and \
          change(user, :bio).to('Lorem ipsum').and \
          change(user, :company).to('@company').and \
          change(user, :company_website).to('https://github.com/company').and \
          change(user, :hireable).to(true)
      end

      it 'does not change empty attributes' do
        github_user = double(
            login: 'johndoe',
            avatar_url: nil,
            name: nil,
            blog: nil,
            location: nil,
            email: nil,
            bio: nil,
            company: nil,
            hireable: nil
        )

        allow(service).to receive(:client_user).and_return github_user

        expect { service.sync }.to change(user, :username).to('johndoe')
        expect(user.name).to be_nil
        expect(user.avatar).to be_nil
        expect(user.website).to be_nil
        expect(user.location).to be_nil
        expect(user.display_email).to be_nil
        expect(user.bio).to be_nil
        expect(user.company).to be_nil
        expect(user.company_website).to be_nil
        expect(user.hireable).to be_nil
      end
    end
  end
end
