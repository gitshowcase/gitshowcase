class EmailSubscriptionService < ApplicationService
  # @param user [User]
  def initialize(user)
    @user = user
    raise 'Email subscription is not enabled' unless self.class.enabled?
  end

  def create
    client_member.upsert(body: {
        email_address: @user.email,
        status: 'subscribed',
        merge_fields: {
            FNAME: @user.first_name,
            NAME: @user.display_name,
            USERNAME: @user.username
        }
    })
  end

  def delete
    client_member.delete
  end

  private

  def self.enabled?
    mailchimp_key.present? && mailchimp_list.present?
  end

  private

  def self.mailchimp_key
    ENV['MAILCHIMP_KEY']
  end

  def self.mailchimp_list
    ENV['MAILCHIMP_LIST_ID']
  end

  def downcase_hashed_email
    Digest::MD5.hexdigest @user.email.downcase
  end

  def self.client
    @client = Gibbon::Request.new(api_key: mailchimp_key)
  end

  def self.client_list
    @client_list = client.lists mailchimp_list
  end

  def client_member
    @client_member = self.class.client_list.members(downcase_hashed_email)
  end
end
