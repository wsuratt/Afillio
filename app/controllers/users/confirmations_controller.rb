# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  private

  def confirmation_url(_resource_name, resource)
    sign_in(resource) # In case you want to sign in the user
    root_path
  end
end
