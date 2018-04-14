require 'crawler'

class SpidersController < ApplicationController
	def dynamic(flags, tmpBuff, dynamicButtons, dynamicText)
		cnt = 0; i = 0

		flags.each do |elem|
			if elem
				dynamicButtons.insert(cnt, tmpBuff[i])
				dynamicText.replace("식당을 선택해주세요!")
				cnt += 1
			end
			i += 1
		end
		return dynamicButtons
	end

	def keyboard
		@msg = {
			type: "buttons",
			buttons: ["도서관 여석 확인", "오늘의 학식"]
		}
		render json: @msg, status: :ok
	end

	def chat
		# notice = Crawler::Notice.new()
		# vacancy = Crawler::Vacancy.new()
		
		@res = params[:content]
		@user_key = params[:user_key]
 
		if @res.eql?("도서관 여석 확인")
			vacancy = Crawler::Vacancy.new()
			@msg = {
				message: {
					text: vacancy.printVacancy
				},
				keyboard: {
					type: "buttons",
					buttons: ["도서관 여석 확인", "오늘의 학식"]
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("오늘의 학식")
			food = Crawler::SchoolFood.new()
			flags = [
				food.studentFoodCourt,
				food.dormFoodCourt[4],
				food.facultyFoodCourt[2]
			]

			tmpBuff = ["학생식당", "기숙사식당", "교직원식당"]
			dynamicButtons = ["처음으로"]
			dynamicText = "오늘은 식당을 운영하지 않습니다."
			dynamic(
				[food.studentFoodCourt,
				food.dormFoodCourt[4],
				food.facultyFoodCourt[2]],
				["학생식당", "기숙사식당", "교직원식당"],
				["처음으로"], dynamicText)

			cnt = 0; i = 0

			flags.each do |elem|
				if elem
					dynamicButtons.insert(cnt, tmpBuff[i])
					dynamicText = "식당을 선택해주세요!"
					cnt += 1
				end
				i += 1
			end

			@msg = {
				message: {
					text: dynamicText
				},
				keyboard: {
					type: "buttons",
					buttons: dynamicButtons
				}
			}

			render json: @msg, status: :ok

		elsif @res.eql?("학생식당")
			food = Crawler::SchoolFood.new()
			@msg = {
				message: {
					text: food.studentFoodCourt
				},
				keyboard: {
					type: "buttons",
					buttons: ["기숙사식당", "교직원식당", "처음으로"] # 추후 뒤로가기 구현
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("기숙사식당")
			# food = Crawler::SchoolFood.new()
			@msg = {
				message: {
					text: "시간대를 선택해 주세요!"
				},
				keyboard: {
					type: "buttons",
					buttons: ["조식", "중식", "석식", "분식", "처음으로"] # 추후 뒤로가기 구현
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("조식")
			food = Crawler::SchoolFood.new()
			@msg = {
				message: {
					text: food.dormFoodCourt[0]
				},
				keyboard: {
					type: "buttons",
					buttons: ["학생식당", "교직원식당", "기숙사식당", "처음으로"] # 추후 뒤로가기 구현
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("중식")
			food = Crawler::SchoolFood.new()
			@msg = {
				message: {
					text: food.dormFoodCourt[1]
				},
				keyboard: {
					type: "buttons",
					buttons: ["학생식당", "교직원식당", "기숙사식당", "처음으로"] # 추후 뒤로가기 구현
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("석식")
			food = Crawler::SchoolFood.new()
			@msg = {
				message: {
					text: food.dormFoodCourt[2]
				},
				keyboard: {
					type: "buttons",
					buttons: ["학생식당", "교직원식당", "기숙사식당", "처음으로"] # 추후 뒤로가기 구현
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("분식")
			food = Crawler::SchoolFood.new()
			@msg = {
				message: {
					text: food.dormFoodCourt[3]
				},
				keyboard: {
					type: "buttons",
					buttons: ["학생식당", "교직원식당", "기숙사식당", "처음으로"] # 추후 뒤로가기 구현
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("교직원식당")
			# food = Crawler::SchoolFood.new()
			@msg = {
				message: {
					text: "시간대를 선택해 주세요!"
				},
				keyboard: {
					type: "buttons",
					buttons: ["[교]중식", "[교]석식", "처음으로"]
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("[교]중식")
			food = Crawler::SchoolFood.new()
			@msg = {
				message: {
					text: food.facultyFoodCourt[0]
				},
				keyboard: {
					type: "buttons",
					buttons: ["학생식당", "기숙사식당", "교직원식당", "처음으로"]
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("[교]석식")
			food = Crawler::SchoolFood.new()
			@msg = {
				message: {
					text: food.facultyFoodCourt[1]
				},
				keyboard: {
					type: "buttons",
					buttons: ["학생식당", "기숙사식당", "교직원식당", "처음으로"]
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("처음으로")
			@msg = {
				message: {
					text: "원하는 기능을 선택해 주세요!"
					},
				keyboard: {
					type: "buttons",
					buttons: ["도서관 여석 확인", "오늘의 학식"]
				}
			}
			render json: @msg, status: :ok
		end
	end
end
