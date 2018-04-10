require 'crawler'
class SpidersController < ApplicationController
		def keyboard
		@msg = {
			type: "buttons",
			buttons: ["도서관 여석 확인", "오늘의 학식", "처음으로"]
		}
		render json: @msg, status: :ok
	end

	def chat
		food = Crawler::SchoolFood.new()
		@res = params[:content]
		@user_key = params[:user_key]
 
		if @res.eql?("도서관 여석 확인")
			@msg = {
				message: {
					text: food.dormFoodCourt
				},
				keyboard: {
					type: "buttons",
					buttons: ["처음으로"]
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
