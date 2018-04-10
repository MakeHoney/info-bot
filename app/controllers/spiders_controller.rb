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
		# food = Crawler::SchoolFood.new()
		@res = params[:content]
		@user_key = params[:user_key]
 
		if @res.eql?("도서관 여석 확인")
			@msg = {
				message: {
					text: "not yet"
				},
				keyboard: {
					type: "buttons",
					buttons: ["처음으로"]
				}
			}
			render json: @msg, status: :ok
		elsif @res.eql?("오늘의 학식")
			@msg = {
				message: {
					text: "2번을 선택하셨네요."
				},
				keyboard: {
					type: "buttons",
					buttons: ["처음으로"]
				}
			}
			render json: @msg, status: :ok
		elsif @res.eql?("처음으로")
			@msg = {
				message: {
					text: "go first."
				},
				keyboard: {
					type: "buttons",
					buttons: ["도서관 여석 확인", "오늘의 학식", "처음으로"]
				}
			}
			render json: @msg, status: :ok
		end
	end
end
