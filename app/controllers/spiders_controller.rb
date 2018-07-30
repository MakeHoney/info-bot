require 'crawler'
require 'uri'

class SpidersController < ApplicationController
	@@dataSetForTransport = {
		stop_1: {
			buttonName: "1. 아주대 정문 (맥날)",
			buttonIdx: "[1]",
			buttonSymbol: :entrance_1
		},
		stop_2: {
			buttonName: "2. 아주대 정문 (KFC)",
			buttonIdx: "[2]",
			buttonSymbol: :entrance_2
		},
		stop_3: {
			buttonName: "3. 창현고, 유신고",
			buttonIdx: "[3]",
			buttonSymbol: :highschool_1
		},
		stop_4: {
			buttonName: "4. 창현고, 유신고",
			buttonIdx: "[4]",
			buttonSymbol: :highschool_2
		},
		stop_5: {
			buttonName: "5. 아주대 후문",
			buttonIdx: "[5]",
			buttonSymbol: :entrance_3
		},
		stop_6: {
			buttonName: "6. 아주대 후문",
			buttonIdx: "[6]",
			buttonSymbol: :entrance_4
		}
	}

	# 버튼을 동적으로 구성하게끔 만들어주는 메소드
	# flags배열의 요소(elem)들 리턴값을 기준으로 버튼을 생성하여
	# dynamicButtons에 버튼을 추가한다.

	def dynamic(flags, tmpBuff, dynamicButtons, dynamicText = false)
		cnt = 0;

		flags.each_with_index do |elem, i|
			if elem
				dynamicButtons.insert(cnt, tmpBuff[i])
				dynamicText.replace("식당을 선택해주세요!") if dynamicText
				cnt += 1
			end
			i += 1
		end
		return dynamicButtons
	end

	def keyboard
		@msg = {
			type: "buttons",
			buttons: ["도서관 여석 확인", "오늘의 학식", "교통 정보"]
		}
		render json: @msg, status: :ok
	end

	def chat
		# declare global variables

		# notice = Crawler::Notice.new()
		food_global = Crawler::SchoolFood.new()
		dButtons = dynamic(
			[food_global.studentFoodCourt,
			food_global.dormFoodCourt[:isOpen],
			food_global.facultyFoodCourt[:isOpen]],
			["학생식당", "기숙사식당", "교직원식당"],
			["처음으로"])

		@res = params[:content]
		@user_key = params[:user_key]


		# 기능 분기문 시작
		# 도서관 기능 #
		if @res.eql?("도서관 여석 확인")
			@msg = {
				message: {
					text: "열람실을 선택해 주세요!"
				},
				keyboard: {
					type: "buttons",
					buttons: ["C1 열람실", "D1 열람실", "처음으로"]
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("C1 열람실")
			vacancy = Crawler::Vacancy.new()
			url = "http://u-campus.ajou.ac.kr/ltms/temp/241.png?t=#{Time.now}"

			@msg = {
				message: {
					text: vacancy.printVacancy[0],
					photo: {
						url: URI.encode(url),
						width: 720,
						height: 630
					},
					message_button: {
						label: "상세정보",
						url: URI.encode(url)
					}
				},
				keyboard: {
					type: "buttons",
					buttons: ["D1 열람실", "C1 열람실 플러그 위치", "처음으로"]
				}
			}

			render json: @msg, status: :ok

		elsif @res.eql?("D1 열람실")
			vacancy = Crawler::Vacancy.new()
			url = "http://u-campus.ajou.ac.kr/ltms/temp/261.png?t=#{Time.now}"

			@msg = {
				message: {
					text: vacancy.printVacancy[1],
					photo: {
						url: URI.encode(url),
						width: 720,
						height: 630
					},
					message_button: {
						label: "상세정보",
						url: URI.encode(url)
					}
				},
				keyboard: {
					type: "buttons",
					buttons: ["C1 열람실", "처음으로"]
				}
			}

			render json: @msg, status: :ok

		elsif @res.eql?("C1 열람실 플러그 위치")
			text = " * 플러그의 위치에 병아리가 있어요.\n
					왼쪽 병아리부터 플러그와 가까운 자리 번호입니다.\n
					(하단의 이미지는 실시간 이미지가 아닙니다.)\n
					349, 380, 405 or 412, 444, 468, 473"
			@msg = {
				message: {
					text: text,
					photo: {
						url: "https://postfiles.pstatic.net/MjAxODA0MTZfNDIg/MDAxNTIzODMwODc5Mjg5.oSjyfCT19ZS4XSE5_AqJGqH9piblcEpPX79vqHJFaVQg.gQi6gQmAX8FgvGh9FHFkY8I7ke2l8V3CrpYZRH0RPm0g.PNG.pourmonreve3/image_3411826531523830501839.png?type=w773",
						width: 720,
						height: 200
					}
				},
				keyboard: {
					type: "buttons",
					buttons: ["D1 열람실", "처음으로"]
				}
			}

			render json: @msg, status: :ok


		# 학식 기능 #
		elsif @res.eql?("오늘의 학식")
			food = Crawler::SchoolFood.new()
			dynamicText = "오늘은 식당을 운영하지 않습니다."
			dynamicButtons = dynamic(
				[food.studentFoodCourt,
				food.dormFoodCourt[:isOpen],
				food.facultyFoodCourt[:isOpen]],
				["학생식당", "기숙사식당", "교직원식당"],
				["처음으로"], dynamicText)

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
			dynamicButtons = dynamic(
				[food.dormFoodCourt[:isOpen],
				food.facultyFoodCourt[:isOpen]],
				["기숙사식당", "교직원식당"],
				["처음으로"])

			@msg = {
				message: {
					text: food.studentFoodCourt
				},
				keyboard: {
					type: "buttons",
					buttons: dynamicButtons
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("기숙사식당")
			food = Crawler::SchoolFood.new()
			dynamicButtons = dynamic(
				[food.dormFoodCourt[:breakfast],
				food.dormFoodCourt[:lunch],
				food.dormFoodCourt[:dinner],
				food.dormFoodCourt[:snack]],
				["조식", "중식", "석식", "분식"],
				["처음으로"])

			@msg = {
				message: {
					text: "시간대를 선택해 주세요!"
				},
				keyboard: {
					type: "buttons",
					buttons: dynamicButtons
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("조식")
			food = Crawler::SchoolFood.new()

			@msg = {
				message: {
					text: food.dormFoodCourt[:breakfast]
				},
				keyboard: {
					type: "buttons",
					buttons: dButtons
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("중식")
			food = Crawler::SchoolFood.new()

			@msg = {
				message: {
					text: food.dormFoodCourt[:lunch]
				},
				keyboard: {
					type: "buttons",
					buttons: dButtons
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("석식")
			food = Crawler::SchoolFood.new()

			@msg = {
				message: {
					text: food.dormFoodCourt[:dinner]
				},
				keyboard: {
					type: "buttons",
					buttons: dButtons
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("분식")
			food = Crawler::SchoolFood.new()

			@msg = {
				message: {
					text: food.dormFoodCourt[:isOpen]
				},
				keyboard: {
					type: "buttons",
					buttons: dButtons
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("교직원식당")
			food = Crawler::SchoolFood.new()
			dynamicButtons = dynamic(
				[food.facultyFoodCourt[:lunch],
				food.facultyFoodCourt[:dinner]],
				["[교]중식", "[교]석식"],
				["처음으로"])

			@msg = {
				message: {
					text: "시간대를 선택해 주세요!"
				},
				keyboard: {
					type: "buttons",
					buttons: dynamicButtons
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("[교]중식")
			food = Crawler::SchoolFood.new()

			@msg = {
				message: {
					text: food.facultyFoodCourt[:lunch]
				},
				keyboard: {
					type: "buttons",
					buttons: dButtons
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("[교]석식")
			food = Crawler::SchoolFood.new()

			@msg = {
				message: {
					text: food.facultyFoodCourt[:dinner]
				},
				keyboard: {
					type: "buttons",
					buttons: dButtons
				}
			}
			render json: @msg, status: :ok

		# 교통 정보 기능 #
	elsif @res.eql?("교통 정보") || @res.eql?("교통 정보(돌아가기)")
			url = "https://user-images.githubusercontent.com/31656287/43041816-71b7ccf0-8da6-11e8-95bd-d50a521b7ed2.jpg"
			buttons = ["* 주요 지역 버스 운행 정보", "1. 아주대 정문 (맥날)", "2. 아주대 정문 (KFC)", "3. 창현고, 유신고", "4. 창현고, 유신고", "5. 아주대 후문", "6. 아주대 후문", "처음으로"]

			@msg = {
				message: {
					text: "정류장을 선택해 주세요!",
					photo: {
						url: url,
						width: 350,
						height: 720
					}
				},
				keyboard: {
					type: "buttons",
					buttons: buttons
				}
			}

			render json: @msg, status: :ok

		elsif @res.eql?(@@dataSetForTransport[:stop_1][:buttonName]) || @res.eql?(@@dataSetForTransport[:stop_2][:buttonName]) ||
					@res.eql?(@@dataSetForTransport[:stop_3][:buttonName]) || @res.eql?(@@dataSetForTransport[:stop_4][:buttonName]) ||
					@res.eql?(@@dataSetForTransport[:stop_5][:buttonName]) || @res.eql?(@@dataSetForTransport[:stop_6][:buttonName])
			dataSet = nil
			@@dataSetForTransport.each do |key, value|
				if value[:buttonName].eql?(@res)
					dataSet = value.dup
					break
				end
			end

			transport = Crawler::Transport.new()
			buttons = []
			base = ["교통 정보(돌아가기)", "처음으로"]

			transport.busesInfo(dataSet[:buttonSymbol]).each do |key, value|
				buttons.unshift("#{key}번#{dataSet[:buttonIdx]}")
			end

			buttons.sort!
			buttons.length > 2 ? text = "버스를 선택해 주세요!" : text = "조회되는 버스가 없습니다."

			buttons.concat(base)

			@msg = {
				message: {
					text: text
				},
				keyboard: {
					type: "buttons",
					buttons: buttons
				}
			}
			render json: @msg, status: :ok

		elsif @res.include?(@@dataSetForTransport[:stop_1][:buttonIdx]) || @res.include?(@@dataSetForTransport[:stop_2][:buttonIdx]) ||
					@res.include?(@@dataSetForTransport[:stop_3][:buttonIdx]) || @res.include?(@@dataSetForTransport[:stop_4][:buttonIdx]) ||
					@res.include?(@@dataSetForTransport[:stop_5][:buttonIdx]) || @res.include?(@@dataSetForTransport[:stop_6][:buttonIdx])
			dataSet = nil
			@@dataSetForTransport.each do |key, value|
				if @res.include?(value[:buttonIdx])
					dataSet = value.dup
					break
				end
			end

			res = @res.dup

			@res.slice! "번#{dataSet[:buttonIdx]}" # 버스 번호
			transport = Crawler::Transport.new()
			buttons = [res, "교통 정보(돌아가기)", "처음으로"]

			busNumText = "#{transport.busesInfo(dataSet[:buttonSymbol])[@res][:number]}\n"
			leftTimeText = "남은 시간: #{transport.busesInfo(dataSet[:buttonSymbol])[@res][:leftTime]}분\n"
			transport.busesInfo(dataSet[:buttonSymbol])[@res][:seats] == "-1" ? leftSeatText = '' : leftSeatText = "남은 좌석: #{transport.busesInfo(dataSet[:buttonSymbol])[@res][:seats]}석\n"
			res = @res.dup
			transport.busesInfo(dataSet[:buttonSymbol])[@res][:isLowPlate] == "1" ? isLowPlateText = "저상 버스: O\n" : isLowPlateText = "저상 버스: X\n"
			vehicleNumText = "차량 번호: #{transport.busesInfo(dataSet[:buttonSymbol])[@res][:vehicleNum]}"

			text = busNumText + leftTimeText + leftSeatText + isLowPlateText + vehicleNumText

			@msg = {
				message: {
					text: text
				},
				keyboard: {
					type: "buttons",
					buttons: buttons
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("* 주요 지역 버스 운행 정보")
			buttons = ["강남역", "사당역", "인천종합터미널", "교통 정보(돌아가기)", "처음으로"]

			@msg = {
				message: {
					text: "선택 지역으로 가는 버스 중 대기시간이 존재하는 버스가 버스번호[정류장번호] 형식으로 제공됩니다."
				},
				keyboard: {
					type: "buttons",
					buttons: buttons
				}
			}
			render json: @msg, status: :ok

		elsif @res.eql?("강남역")
			transport = Crawler::Transport.new()
			buttons = []
			base = ["교통 정보(돌아가기)", "처음으로"]

			transport.busesInfo(:entrance_1).each do |key, value|
				buttons.unshift("#{key}번[1]") if key.eql?('직행3007') || key.eql?('직행3008')
			end

			buttons.sort!

			buttons.concat(base)
			buttons.length > 2 ? text = "버스를 선택해 주세요!" : text = "조회되는 버스가 없습니다."

			@msg = {
				message: {
					text: text
				},
				keyboard: {
					type: "buttons",
					buttons: buttons
				}
			}

			render json: @msg, status: :ok

		elsif @res.eql?("사당역")
			transport = Crawler::Transport.new()
			buttons = []
			base = ["교통 정보(돌아가기)", "처음으로"]

			transport.busesInfo(:entrance_1).each do |key, value|
				buttons.unshift("#{key}번[1]") if key.eql?('직행7000')
			end

			transport.busesInfo(:entrance_3).each do |key, value|
				buttons.unshift("#{key}번[5]") if key.eql?('직행7002')
			end

			buttons.sort!

			buttons.concat(base)
			buttons.length > 2 ? text = "버스를 선택해 주세요!" : text = "조회되는 버스가 없습니다."

			@msg = {
				message: {
					text: text
				},
				keyboard: {
					type: "buttons",
					buttons: buttons
				}
			}

			render json: @msg, status: :ok

		elsif @res.eql?("인천종합터미널")
			transport = Crawler::Transport.new()
			buttons = []
			base = ["교통 정보(돌아가기)", "처음으로"]

			transport.busesInfo(:highschool_1).each do |key, value|
				buttons.unshift("#{key}번[3]") if key.eql?('시외8862')
			end

			buttons.sort!

			buttons.concat(base)
			buttons.length > 2 ? text = "버스를 선택해 주세요!" : text = "조회되는 버스가 없습니다."

			@msg = {
				message: {
					text: text
				},
				keyboard: {
					type: "buttons",
					buttons: buttons
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
					buttons: ["도서관 여석 확인", "오늘의 학식", "교통 정보"]
				}
			}
			render json: @msg, status: :ok
		end
	end
end
