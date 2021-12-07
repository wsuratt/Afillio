# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Afillio <support@afillio.com>'
  layout 'mailer'
end
