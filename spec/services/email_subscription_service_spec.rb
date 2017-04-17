require 'rails_helper'

RSpec.describe EmailSubscriptionService, type: :service do
  context 'enabled' do
    let!(:client_member) { double.as_null_object }

    before {
      allow(EmailSubscriptionService).to receive(:enabled?).and_return(true)
      allow_any_instance_of(EmailSubscriptionService).to receive(:client_member).and_return(client_member)
    }

    let(:user) { FactoryGirl.build(:user, email: 'email', name: 'john doe', username: 'little_john') }
    let(:service) { EmailSubscriptionService.new(user) }

    describe '#create' do
      after { service.create }

      it 'calls client' do
        params = {
            body: {
                email_address: 'email',
                status: 'subscribed',
                merge_fields: {
                    FNAME: 'john',
                    NAME: 'john doe',
                    USERNAME: 'little_john'
                }
            }
        }

        expect(client_member).to receive(:upsert).once.with(params)
      end
    end

    describe '#delete' do
      after { service.delete }

      it 'calls client' do
        expect(client_member).to receive(:delete).once
      end
    end
  end

  context 'disabled' do
    before { allow(EmailSubscriptionService).to receive(:enabled?).and_return(false) }

    describe '#initialize' do
      it 'raises message' do
        expect { EmailSubscriptionService.new('email') }.to raise_error('Email subscription is not enabled')
      end
    end
  end
end
