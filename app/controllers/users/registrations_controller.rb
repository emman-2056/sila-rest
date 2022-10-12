class Users::RegistrationsController < Devise::RegistrationsController  
  respond_to :json

  def create


    # render json: {
    #   data1: sign_up_params.has_key?(:email)
    # }

    if sign_up_params.has_key?(:email) && sign_up_params.has_key?(:password)
        build_resource(sign_up_params)
        begin 
          resource.save
          yield resource if block_given?
          if resource.persisted?
            if resource.active_for_authentication?
              set_flash_message! :notice, :signed_up
              sign_up(resource_name, resource)
              respond_with resource, location: after_sign_up_path_for(resource)
            else
              set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
              expire_data_after_sign_in!
              respond_with resource, location: after_inactive_sign_up_path_for(resource)
            end
          else
            clean_up_passwords resource
            set_minimum_password_length
            respond_with resource
          end
        rescue ActiveRecord::RecordNotUnique #in begin method "resource.save" will produce fatal error, So we handle it like rescue
          respond_with(resource, '', 'failed', 'Email ID already exists!')
        end
    else
        respond_with(resource, '', 'failed', 'Email and Password fields are required!')
    end




    
  end

  private
    def respond_with(resource, _opts = {}, status = 'success', status_msg = '')
      if status == 'failed' && status_msg != ''
        render json: {
          status: {code:409, message: status_msg},
          data: resource
        }, status: 409
      elsif resource.persisted?
        render json: {
          status: {code: 200, message: 'Signed up sucessfully.'},
          data: resource
        }
      else
        render json: {
          status: {message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
        }, status: :unprocessable_entity
      end
    end
end
