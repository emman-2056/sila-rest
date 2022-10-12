class Api::V1::UsersController < ApplicationController
    respond_to :json
    # before_action :authenticate_user!

    def index

        require 'aws-sdk-s3'
        s3 = Aws::S3::Resource.new({
            region: ENV['AWS_REGION'],
            access_key_id: ENV['AWS_ACCESS_KEY_ID'],
            secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
        })

        #  --> Reference https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Presigner.html#initialize-instance_method
        signer = Aws::S3::Presigner.new
        url, headers = signer.presigned_request(
            :get_object, bucket: "shareandremember", key: "captain.jpg"
        )

        json_responder({
            "url": url
        })
        
    end

    def splitBase64(uri)
        if uri.match(%r{^data:(.*?);(.*?),(.*)$})
            return {
                type:      $1, # "image/png"
                encoder:   $2, # "base64"
                data:      $3, # data string
                extension: $1.split('/')[1] # "png"
            }
        end
    end

    def checkNewUsers

        usersList = [
            {
                "name" => "raja",
                "role" => "father"
            },
            {
                "name" => "vijaya",
                "role" => "mother"
            }
        ]
        render json: usersList
    end

    def createNewUser
        

    end

    def getResult

        render json: {
            "name" => "emman"
        }
    end
    
    
end
