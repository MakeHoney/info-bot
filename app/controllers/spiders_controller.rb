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
		notice = Crawler::Notice.new()
		vacancy = Crawler::Vacancy.new()
		
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
					text: "식당을 선택해주세요!"
				},
				keyboard: {
					type: "buttons",
					buttons: ["학생식당", "기숙사식당"]
				}
			}
			render json: @msg, status: :ok
		elsif @res.eql?("학생식당")
			@msg = {
				message: {
					text: food.studentFoodCourt
				},
				keyboard: {
					type: "buttons",
					buttons: ["처음으로"] # 추후 뒤로가기 구현
				}
			}
			render json:@msg, status: :ok
		elsif @res.eql?("기숙사식당")
			@msg = {
				message: {
					text: food.dormFoodCourt
				},
				keyboard: {
					type: "buttons",
					buttons: ["처음으로"] # 추후 뒤로가기 구현
				}
			}
			render json:@msg, status: :ok
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
