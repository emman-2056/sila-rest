class Api::V1::SharesController < ApplicationController

    include EncrytionAlgo

    def index
        # vars = request.query_parameters

        str = "user_id=10"
        ecryptedStr = encrypt(str)
        decryptedStr = decrypt(ecryptedStr)

        render json: {
            data: {
                original_string: str,
                encrypted_string: ecryptedStr,
                decrypted_string: decryptedStr
            }
        }
    end
end
