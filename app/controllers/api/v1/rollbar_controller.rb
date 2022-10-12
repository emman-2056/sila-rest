class Api::V1::RollbarController < ApplicationController

    def index
        # return render json: {
        #     "name" => "emmanuel"
        # }


        tbl_values = {
            "name" => "emman",
            "email" => "emman2056@gmail.com"
        }

        save_tb_val = RollbarTable.new(tbl_values)

        if save_tb_val.save
            msg = 'saved successfully'
        else
            msg = 'somthing went wrong'
        end

        return render json: {
            "message" => msg
        }


    end
end

