class ApplicationController < ActionController::API
    # include EncrytionAlgo
    before_action :skip_cookies

    def skip_cookies  #This method is to disable the cookie while using JWT auth method
        request.session_options[:skip] = true
    end

    def json_responder(data)
        render json: {
            data: data
        }
    end
end
