require 'rails_helper'

RSpec.describe DomainService, type: :service do
  before do
    allow(DomainService).to receive(:client_domain).and_return(double.as_null_object)
    allow(DomainService).to receive(:heroku_app).and_return('123')
  end

  context 'enabled' do
    before { allow(DomainService).to receive(:enabled?).and_return(true) }

    context 'without app domain' do
      describe '#initialize' do
        it 'raises without APP_DOMAIN' do
          ENV['APP_DOMAIN'] = nil
          expect { DomainService.new('domain.con') }.to raise_exception('Undefined APP_DOMAIN variable')
        end
      end
    end

    context 'with app domain' do
      before { ENV['APP_DOMAIN'] = 'app-domain.com' }

      describe '#initialize' do
        it 'does not allow app domain to be used' do
          expect { DomainService.new('app-domain.com') }.to raise_exception('Invalid domain')
        end

        it 'allows valid' do
          expect { DomainService.new('domain.com') }.to_not raise_exception
        end

        it 'extracts url' do
          service = DomainService.new('www.domain.com/test')
          expect(service.instance_variable_get(:@domain)).to eq('domain.com/test')
        end
      end

      describe '#available' do
        let(:user) { FactoryGirl.create(:user, domain: 'domain.com') }
        let(:service) { DomainService.new('domain.com') }

        it 'validates correct' do
          expect(service.available(user.id)).to eq(true)
        end

        it 'invalidates incorrect' do
          expect(service.available(user.id + 1)).to eq(false)
        end
      end

      describe '#add' do
        after { DomainService.new('domain.com').add }

        it 'calls client to create' do
          expect(DomainService.client_domain).to receive(:create).with('123', hostname: 'domain.com')
        end

        it 'calls client to create with www' do
          expect(DomainService.client_domain).to receive(:create).with('123', hostname: 'www.domain.com')
        end
      end

      describe '#remove' do
        after { DomainService.new('domain.com').remove }

        it 'calls client to delete' do
          expect(DomainService.client_domain).to receive(:delete).with('123', 'domain.com')
        end

        it 'calls client to delete with www' do
          expect(DomainService.client_domain).to receive(:delete).with('123', 'www.domain.com')
        end
      end
    end
  end

  context 'disabled' do
    before { allow(DomainService).to receive(:enabled?).and_return(false) }

    describe '#initialize' do
      it 'raises' do
        expect { DomainService.new('domain') }.to raise_exception('Domain management is not enabled')
      end
    end
  end
end
