class Api::V1::CognitoController < ApplicationController

    # @client = Aws::CognitoIdentityProvider::Client.new


    @@client = Aws::CognitoIdentityProvider::Client.new({
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    })


    def create_user
        postData = params[:cognito]
        
        auth_object = {
          client_id: ENV['AWS_COGNITO_APP_CLIENT_ID'],
          username: postData[:username],
          password: postData[:password],
          user_attributes: [
            {
              name: "email",
              value: postData[:email]
            },
            {
              name: "gender",
              value: postData[:gender]
            }
          ]
        }


        

        signup_req = @client.sign_up(auth_object)

        render json: {
            signup_req: signup_req,
            # base64: base64
        }
    end


    def confirm_signup
        signup_code = params[:cognito][:signup_code]
        client = Aws::CognitoIdentityProvider::Client.new({
            region: ENV['AWS_REGION'],
            access_key_id: ENV['AWS_ACCESS_KEY_ID'],
            secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
        })
        conf_signup = client.confirm_sign_up({
            client_id: ENV['AWS_COGNITO_APP_CLIENT_ID'],
            username: 'emman2056',
            confirmation_code: signup_code
        })

        render json: {
            conf_signup: conf_signup
        }
    end

    def sign_in

        username = params[:cognito][:username]
        password = params[:cognito][:password]

        init_auth = @@client.initiate_auth({
            auth_flow: "USER_PASSWORD_AUTH",
            auth_parameters: {
              "USERNAME" => username,
              "PASSWORD" => password
            },
            client_id: ENV['AWS_COGNITO_APP_CLIENT_ID']
        })

        render json: {
            "client": init_auth
        }
    end


    def get_user

        token = request.headers["token"]        
        resp = @@client.get_user({
            access_token: token
        })
        render json: {
            "resp" => resp
        }
    end

    def sign_out
        token = request.headers["token"]
        
        resp = @@client.global_sign_out({
            access_token: token
        })

        render json: {
            "resp" => resp
        }
    end
end
