module MailchimpUser
  extend ActiveSupport::Concern

  class_methods do
    def mailchimp_client
      @mailchimp_client = Gibbon::Request.new(api_key: ENV['MAILCHIMP_KEY'])
    end

    def mailchimp_client_list
      @mailchimp_client_list = mailchimp_client.lists(ENV['MAILCHIMP_LIST_ID'])
    end
  end

  included do
    if ENV['MAILCHIMP_KEY'].present? and ENV['MAILCHIMP_LIST_ID'].present?
      after_create :mailchimp_subscribe
      after_update :mailchimp_subscribe_changed
      after_destroy :mailchimp_unsubscribe
    end
  end

  def mailchimp_member
    self.class.mailchimp_client_list.members(downcase_hashed_email)
  end

  def mailchimp_subscribe
    body = {
        email_address: email,
        status: 'subscribed',
        merge_fields: {
            FNAME: first_name,
            NAME: name,
            USERNAME: username,
            LOCATION: location
        }
    }

    mailchimp_member.upsert(body: body)
  end

  def mailchimp_subscribe_changed
    mailchimp_subscribe if email_changed?
  end

  def mailchimp_unsubscribe
    mailchimp_member.delete
  end

  protected

  def downcase_hashed_email
    Digest::MD5.hexdigest email.downcase
  end
end
