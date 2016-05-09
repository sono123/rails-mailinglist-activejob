class MailingListSignupJob < ActiveJob::Base

	def perform(user)
		logger.info "Signing up #{user.email}"
		subscribe(user)
	end

	def subscribe(user)
    mailchimp = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
    list_id = Rails.application.secrets.mailchimp_list_id
    result = mailchimp.lists(list_id).members.create(
      body: {
        email_address: user.email,
        status: 'subscribed'
    })
    Rails.logger.info("Subscribed #{user.email} to MailChimp") if result
  rescue Gibbon::MailChimpError => e
  	Rails.logger.info("MailChimp subscribe failed for #{self.email}: " + e.message)
  end

end