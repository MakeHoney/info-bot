class SpidersController < ApplicationController
		def keyboard
		@msg = {
			type: "buttons",
			buttons: ["1", "2", "3"]
		}
		render json: @msg, status: :ok
	end

	def chat
		@res = params[:content]
		@user_key = params[:user_key]
 
		if @res == "1"
			@msg = {
				message: {
					text: "1번을 선택하셨네요."
				},
				keyboard: {
					type: "buttons",
					buttons: ["5", "6", "2"]
				}
			}
			render json: @msg, status: :ok
		elsif @res == "2"
			@msg = {
				message: {
					text: "2번을 선택하셨네요."
				},
				keyboard: {
					type: "buttons",
					buttons: ["1", "3", "2"]
				}
			}
			render json: @msg, status: :ok
		elsif @res == "5"
			@msg = {
				message: {
					text: "5번을 선택하셨네요."
				},
				keyboard: {
					type: "buttons",
					text: "끝!"
				}
			}
			render json: @msg, status: :ok
		end
	end
end
