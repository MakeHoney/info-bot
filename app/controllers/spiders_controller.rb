require 'crawler'
require 'uri'
require 'data_set'
require 'utils'

class SpidersController < ApplicationController
    include Utils

    def initialize
        _ButtonInfo = DataSet::ForController.ButtonInfoForTransport
        @dataSetForTransport = _ButtonInfo[:metaData]
        @buttonNames = _ButtonInfo[:name]
        @msg = {
            type: "buttons",
            buttons: ["도서관 여석 확인", "오늘의 학식", "교통 정보"]
        }
    end

	def keyboard
		render json: @msg, status: :ok
	end

	def chat
        @res = params[:content]
        @user_key = params[:user_key]
        
        # LIBRARY #
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
            _vacancy = Crawler::Vacancy
			_url = "http://u-campus.ajou.ac.kr/ltms/temp/241.png?t=#{Time.now}"
			@msg = {
				message: {
					text: _vacancy.printVacancy("C1"),
					photo: {
						url: URI.encode(_url),
						width: 720,
						height: 630
					},
					message_button: {
						label: "상세정보",
						url: URI.encode(_url)
					}
				},
				keyboard: {
					type: "buttons",
					buttons: ["D1 열람실", "C1 열람실", "C1 열람실 플러그 위치", "처음으로"]
				}
			}

			render json: @msg, status: :ok

        elsif @res.eql?("D1 열람실")
            _vacancy = Crawler::Vacancy
			_url = "http://u-campus.ajou.ac.kr/ltms/temp/261.png?t=#{Time.now}"
			@msg = {
				message: {
					text: _vacancy.printVacancy("D1"),
					photo: {
						url: URI.encode(_url),
						width: 720,
						height: 630
					},
					message_button: {
						label: "상세정보",
						url: URI.encode(_url)
					}
				},
				keyboard: {
					type: "buttons",
					buttons: ["C1 열람실", "D1 열람실", "처음으로"]
				}
			}

			render json: @msg, status: :ok

		elsif @res.eql?("C1 열람실 플러그 위치")
            _url = "https://postfiles.pstatic.net/MjAxODA0MTZfNDIg/MDAxNTIzODMwODc5Mjg5.oSjyfCT19ZS4XSE5_AqJGqH9piblcEpPX79vqHJFaVQg.gQi6gQmAX8FgvGh9FHFkY8I7ke2l8V3CrpYZRH0RPm0g.PNG.pourmonreve3/image_3411826531523830501839.png?type=w773"
            # 앱 내에서의 메시지 형태 확인하기
			_text = " * 플러그의 위치에 병아리가 있어요.\n
					왼쪽 병아리부터 플러그와 가까운 자리 번호입니다.\n
					(하단의 이미지는 실시간 이미지가 아닙니다.)\n
					349, 380, 405 or 412, 444, 468, 473"
            
			@msg = {
				message: {
					text: _text,
					photo: {
						url: _url,
						width: 720,
						height: 200
					}
				},
				keyboard: {
					type: "buttons",
					buttons: ["C1 열람실", "D1 열람실", "처음으로"]
				}
			}

			render json: @msg, status: :ok

        # FOOD #
        elsif @res.eql?("오늘의 학식")
            _defaultText = "오늘은 식당을 운영하지 않습니다."
			_dynamicText = _defaultText
			_dynamicButtons = dynamic([
                foodInfo('stuFoodCourt'),
                foodInfo('dormIsOpen'),
                foodInfo('facuIsOpen')
            ],
			["학생식당", "기숙사식당", "교직원식당"],
            ["처음으로"], 
            _dynamicText
            )

			@msg = {
				message: {
					text: _dynamicText
				},
				keyboard: {
					type: "buttons",
					buttons: _dynamicButtons
				}
			}

			render json: @msg, status: :ok

        elsif @res.eql?("학생식당")
			_dynamicButtons = dynamic([
                foodInfo('dormIsOpen'),
                foodInfo('facuIsOpen')
            ],
            ["기숙사식당", "교직원식당"],
            ["처음으로"]
            )

			@msg = {
				message: {
					text: foodInfo('stuFoodCourt')
				},
				keyboard: {
					type: "buttons",
					buttons: _dynamicButtons
				}
			}
			render json: @msg, status: :ok

        elsif @res.eql?("기숙사식당")
			_dynamicButtons = dynamic([
                foodInfo('dormBreakfast'),
				foodInfo('dormLunch'),
                foodInfo('dormDinner')
            ],
            ["조식", "중식", "석식"],
            ["처음으로"]
            )

			@msg = {
				message: {
					text: "시간대를 선택해 주세요!"
				},
				keyboard: {
					type: "buttons",
					buttons: _dynamicButtons
				}
			}
			render json: @msg, status: :ok

        elsif @res.eql?("조식")
            @dButtons = dynamic([
                foodInfo('stuFoodCourt'),
                foodInfo('dormIsOpen'),
                foodInfo('facuIsOpen')
            ],
            ["학생식당", "기숙사식당", "교직원식당"],
            ["처음으로"]
            )
			@msg = {
				message: {
					text: foodInfo('dormBreakfast')
				},
				keyboard: {
					type: "buttons",
					buttons: @dButtons
				}
			}
			render json: @msg, status: :ok

        elsif @res.eql?("중식")
            @dButtons = dynamic([
                foodInfo('stuFoodCourt'),
                foodInfo('dormIsOpen'),
                foodInfo('facuIsOpen')
            ],
            ["학생식당", "기숙사식당", "교직원식당"],
            ["처음으로"]
            )
			@msg = {
				message: {
					text: foodInfo('dormLunch')
				},
				keyboard: {
					type: "buttons",
					buttons: @dButtons
				}
			}
			render json: @msg, status: :ok

        elsif @res.eql?("석식")
            @dButtons = dynamic([
                foodInfo('stuFoodCourt'),
                foodInfo('dormIsOpen'),
                foodInfo('facuIsOpen')
            ],
            ["학생식당", "기숙사식당", "교직원식당"],
            ["처음으로"]
            )
			@msg = {
				message: {
					text: foodInfo('dormDinner')
				},
				keyboard: {
					type: "buttons",
					buttons: @dButtons
				}
			}
			render json: @msg, status: :ok

        elsif @res.eql?("교직원식당")
			_dynamicButtons = dynamic([
                foodInfo('facuLunch'),
                foodInfo('facuDinner')
            ],
			["[교]중식", "[교]석식"],
            ["처음으로"]
            )

			@msg = {
				message: {
					text: "시간대를 선택해 주세요!"
				},
				keyboard: {
					type: "buttons",
					buttons: _dynamicButtons
				}
			}
			render json: @msg, status: :ok

        elsif @res.eql?("[교]중식")
            @dButtons = dynamic([
                foodInfo('stuFoodCourt'),
                foodInfo('dormIsOpen'),
                foodInfo('facuIsOpen')
            ],
            ["학생식당", "기숙사식당", "교직원식당"],
            ["처음으로"]
            )
			@msg = {
				message: {
					text: foodInfo('facuLunch')
				},
				keyboard: {
					type: "buttons",
					buttons: @dButtons
				}
			}
			render json: @msg, status: :ok

        elsif @res.eql?("[교]석식")
            @dButtons = dynamic([
                foodInfo('stuFoodCourt'),
                foodInfo('dormIsOpen'),
                foodInfo('facuIsOpen')
            ],
            ["학생식당", "기숙사식당", "교직원식당"],
            ["처음으로"]
            )
			@msg = {
				message: {
					text: foodInfo('facuDinner')
				},
				keyboard: {
					type: "buttons",
					buttons: @dButtons
				}
			}
			render json: @msg, status: :ok

		# TRANSPORT #
	    elsif @res.eql?("교통 정보") || @res.eql?("교통 정보(돌아가기)")
			_url = "https://user-images.githubusercontent.com/31656287/43041816-71b7ccf0-8da6-11e8-95bd-d50a521b7ed2.jpg"
            _buttons = @buttonNames.dup
            _buttons.unshift("0. 주요 지역 버스 운행 정보")
            _buttons.push("처음으로")

			@msg = {
				message: {
					text: "정류장을 선택해 주세요!",
					photo: {
						url: _url,
						width: 350,
						height: 720
					}
				},
				keyboard: {
					type: "buttons",
					buttons: _buttons
				}
			}

			render json: @msg, status: :ok

        elsif @res.eql?(@buttonNames[0]) || @res.eql?(@buttonNames[1]) ||
                @res.eql?(@buttonNames[2]) || @res.eql?(@buttonNames[3]) ||
                @res.eql?(@buttonNames[4]) || @res.eql?(@buttonNames[5])
            
            _transport = Crawler::Transport
            _base = ["교통 정보(돌아가기)", "처음으로"]
            _buttons = []
            _dataSet = nil
            
            _keys = @dataSetForTransport.keys
			@buttonNames.each_with_index do |button, i|
                if button.eql?(@res)
                    _dataSet = @dataSetForTransport[_keys[i]].dup
					break
				end
            end
            
            _buttonSymbol = _dataSet[:buttonSymbol]
            _arrivalBuses = _transport.busesInfo(_buttonSymbol)

			_arrivalBuses.each do |key, value|
				_buttons.push("#{key}번#{_dataSet[:buttonIdx]}")
			end

			_buttons.sort!
            _buttons.length > 0 ? 
            _text = "버스를 선택해 주세요!\n괄호 속 숫자는 정류장 번호입니다." : 
            _text = "조회되는 버스가 없습니다."
			_buttons.concat(_base)

			@msg = {
				message: {
					text: _text
				},
				keyboard: {
					type: "buttons",
					buttons: _buttons
				}
			}
			render json: @msg, status: :ok

        elsif @res.include?('[1]') || @res.include?('[2]') ||
                @res.include?('[3]') || @res.include?('[4]') ||
                @res.include?('[5]') || @res.include?('[6]')
            
            _transport = Crawler::Transport
            _dataSet = nil
			@dataSetForTransport.each do |key, value|
				if @res.include?(value[:buttonIdx])
					_dataSet = value.dup
					break
				end
			end
            _res = @res.dup
            @res.slice! "번#{_dataSet[:buttonIdx]}" # 버스 번호

            _buttonSymbol = _dataSet[:buttonSymbol]
            _arrivalBuses = _transport.busesInfo(_buttonSymbol)
            _bus = _arrivalBuses[@res]            
                        
			_buttons = [_res, "교통 정보(돌아가기)", "처음으로"]
			_busNumText = "#{_bus[:number]}\n"
			_leftTimeText = "남은 시간: #{_bus[:leftTime]}분\n"
            _vehicleNumText = "차량 번호: #{_bus[:vehicleNum]}"
            
            _bus[:seats] == "-1" ? 
            _leftSeatText = '' : 
            _leftSeatText = "남은 좌석: #{_bus[:seats]}석\n"

            _bus[:isLowPlate] == "1" ?
            _isLowPlateText = "저상 버스: O\n" : 
            _isLowPlateText = "저상 버스: X\n"

			_text = _busNumText + _leftTimeText + _leftSeatText + _isLowPlateText + _vehicleNumText

			@msg = {
				message: {
					text: _text
				},
				keyboard: {
					type: "buttons",
                    buttons: _buttons
                }
            }
            render json: @msg, status: :ok

		elsif @res.eql?("0. 주요 지역 버스 운행 정보")
			_buttons = ["강남역", "사당역", "인천종합터미널", "인계동(나혜석거리)", "수원역", "교통 정보(돌아가기)", "처음으로"]

			@msg = {
				message: {
					text: "대기시간이 존재하는 버스가 제공됩니다."
				},
				keyboard: {
					type: "buttons",
					buttons: _buttons
				}
			}
			render json: @msg, status: :ok

        elsif @res.eql?("강남역")
            _transport = Crawler::Transport
			_buttons = ["0. 주요 지역 버스 운행 정보", "교통 정보(돌아가기)", "처음으로"]
			_buses = []
            _ent1ArrivalBuses = _transport.busesInfo(:entrance_1)

			_ent1ArrivalBuses.each do |key, value|
				_buses.push("#{key}") if key.eql?('직행3007') || key.eql?('직행3008')
			end

            _buses.length > 0 ? 
            _text = "괄호 속 숫자는 정류장 번호입니다.\n\n직행3007: 강남역.역삼세무서 하차\n직행3008: 강남역나라빌딩앞 하차\n\n" : 
            _text = "조회되는 버스가 없습니다."

            _buses.each do |bus|
                bus = _ent1ArrivalBuses[bus]
				_busNumText = "#{bus[:number]} [1]\n"
				_leftTimeText = "남은 시간: #{bus[:leftTime]}분\n"
                _vehicleNumText = "차량 번호: #{bus[:vehicleNum]}\n\n"
                
                bus[:seats] == "-1" ? 
                _leftSeatText = '' : 
                _leftSeatText = "남은 좌석: #{bus[:seats]}석\n"

                bus[:isLowPlate] == "1" ? 
                _isLowPlateText = "저상 버스: O\n" : 
                _isLowPlateText = "저상 버스: X\n"

				_text += _busNumText + _leftTimeText + _leftSeatText + _isLowPlateText + _vehicleNumText
			end
			# chomp doesn't work
            _text.chomp!
            
			@msg = {
				message: {
					text: _text
				},
				keyboard: {
					type: "buttons",
					buttons: _buttons
				}
			}

			render json: @msg, status: :ok

        elsif @res.eql?("사당역")
            _transport = Crawler::Transport
			_buttons = ["0. 주요 지역 버스 운행 정보", "교통 정보(돌아가기)", "처음으로"]
            _busStops = []
            _buses = {}

            _ent1ArrivalBuses = _transport.busesInfo(:entrance_1)
            _ent3ArrivalBuese = _transport.busesInfo(:entrance_3)

			_ent1ArrivalBuses.each do |key, value|
                if key.eql?('직행7000')
                    # _buses.push("#{key}")
                    # 아래 구조(buses[:entrance_1] = key 의 구조)는 임시 방편
                    # 문제가 있는 자료구조임 (한 정류장에 버스가 2대 이상이 되는 경우 확장성 x)
                    _buses[:entrance_1] = "#{key}"
                    _busStops.push(:entrance_1)
                end
			end

            _ent3ArrivalBuese.each do |key, value|
                if key.eql?('직행7002')
                    # _buses.push("#{key}")
                    _buses[:entrance_3] = "#{key}"
                    _busStops.push(:entrance_3)
                end
			end
            _buses.length > 0 ? 
            _text = "괄호 속 숫자는 정류장 번호입니다.\n\n직행7000[1]: 사당역 하차\n직행7002[1]: 사당역 하차\n\n" : 
            _text = "조회되는 버스가 없습니다."

            _busStops.each do |busStop|    
                #     # 예외처리 ?
                _bus = _transport.busesInfo(busStop)[_buses[busStop]]

                _busNumText = "#{_bus[:number]}\n"
                _leftTimeText = "남은 시간: #{_bus[:leftTime]}분\n"
                _vehicleNumText = "차량 번호: #{_bus[:vehicleNum]}\n\n"

                _bus[:seats] == "-1" ? 
                _leftSeatText = '' : 
                _leftSeatText = "남은 좌석: #{_bus[:seats]}석\n"

                _bus[:isLowPlate] == "1" ? 
                _isLowPlateText = "저상 버스: O\n" : 
                _isLowPlateText = "저상 버스: X\n"

                _text += _busNumText + _leftTimeText + _leftSeatText + _isLowPlateText + _vehicleNumText
			end
			_text.chomp!

			@msg = {
				message: {
					text: _text
				},
				keyboard: {
					type: "buttons",
					buttons: _buttons
				}
			}

			render json: @msg, status: :ok

        elsif @res.eql?("인천종합터미널")
            _transport = Crawler::Transport
			_buttons = ["0. 주요 지역 버스 운행 정보", "교통 정보(돌아가기)", "처음으로"]
            _buses = []
            
            _high1ArrivalBuses = _transport.busesInfo(:highschool_1)
            _high2ArrivalBuses = _transport.busesInfo(:highschool_2)

			_high2ArrivalBuses.each do |key, value|
				_buses.push("#{key}") if key.eql?('시외8862')
			end

            _buses.length > 0 ? 
            _text = "괄호 속 숫자는 정류장 번호입니다.\n\n시외8862: 인천터미널 하차\n\n" : 
            _text = "조회되는 버스가 없습니다."

            _buses.each do |bus|
                bus = _high1ArrivalBuses[bus]
				_busNumText = "#{bus[:number]} [3]\n"
				_leftTimeText = "남은 시간: #{bus[:leftTime]}분\n"
                _vehicleNumText = "차량 번호: #{bus[:vehicleNum]}\n\n"
                
                bus[:seats] == "-1" ? 
                _leftSeatText = '' : 
                _leftSeatText = "남은 좌석: #{bus[:seats]}석\n"

                bus[:isLowPlate] == "1" ? 
                _isLowPlateText = "저상 버스: O\n" : 
                _isLowPlateText = "저상 버스: X\n"

				_text += _busNumText + _leftTimeText + _leftSeatText + _isLowPlateText + _vehicleNumText
			end
			_text.chomp!

			@msg = {
				message: {
					text: _text
				},
				keyboard: {
					type: "buttons",
					buttons: _buttons
				}
			}

			render json: @msg, status: :ok

        elsif @res.eql?("인계동(나혜석거리)")
            _transport = Crawler::Transport
			_buttons = ["0. 주요 지역 버스 운행 정보", "교통 정보(돌아가기)", "처음으로"]
            _buses = []
            
            _ent1ArrivalBuses = _transport.busesInfo(:entrance_1)
            _ent2ArrivalBuses = _transport.busesInfo(:entrance_2)

			_ent1ArrivalBuses.each do |key, value|
				if key.eql?('202') || key.eql?('80') || key.eql?('81') ||
					key.eql?('88-1') || key.eql?('85') || key.eql?('99-2')
					_buses.push("#{key}")
				end
			end

            _buses.length > 0 ? 
            _text = "괄호 속 숫자는 정류장 번호입니다.\n\n202, 99-2 : 중소기업은행 하차\n80, 81, 85, 88-1 : 자유총연맹 하차\n\n" : 
            _text = "조회되는 버스가 없습니다."

            _buses.each do |bus|
                bus = _ent2ArrivalBuses[bus]
				_busNumText = "#{bus[:number]} [2]\n"
				_leftTimeText = "남은 시간: #{bus[:leftTime]}분\n"
                _vehicleNumText = "차량 번호: #{bus[:vehicleNum]}\n\n"
                
                bus[:seats] == "-1" ? 
                _leftSeatText = '' : 
                _leftSeatText = "남은 좌석: #{bus[:seats]}석\n"
                
                bus[:isLowPlate] == "1" ? 
                _isLowPlateText = "저상 버스: O\n" : 
                _isLowPlateText = "저상 버스: X\n"

				_text += _busNumText + _leftTimeText + _leftSeatText + _isLowPlateText + _vehicleNumText
			end
			_text.chomp!

			@msg = {
				message: {
					text: _text
				},
				keyboard: {
					type: "buttons",
					buttons: _buttons
				}
			}

			render json: @msg, status: :ok

        elsif @res.eql?("수원역")
            _transport = Crawler::Transport
			_buttons = ["0. 주요 지역 버스 운행 정보", "교통 정보(돌아가기)", "처음으로"]
            _buses = []
            
            _ent2ArrivalBuses = _transport.busesInfo(:entrance_2)

			_ent2ArrivalBuses.each do |key, value|
				if key.eql?('720-2') || key.eql?('13-4') || key.eql?('9-2') || key.eql?('11-1')||
					key.eql?('32-4') || key.eql?('32-3') || key.eql?('32')
					_buses.push("#{key}")
				end
			end

            _buses.length > 0 ? 
            _text = "괄호 속 숫자는 정류장 번호입니다.\n\n모두 수원역.AK플라자 하차\n\n" : 
            _text = "조회되는 버스가 없습니다."

            _buses.each do |bus|
                bus = _ent2ArrivalBuses[bus]
				_busNumText = "#{bus[:number]} [2]\n"
				_leftTimeText = "남은 시간: #{bus[:leftTime]}분\n"
                _vehicleNumText = "차량 번호: #{bus[:vehicleNum]}\n\n"
                
                bus[:seats] == "-1" ? 
                _leftSeatText = '' : 
                _leftSeatText = "남은 좌석: #{bus[:seats]}석\n"
                
                bus[:isLowPlate] == "1" ? 
                _isLowPlateText = "저상 버스: O\n" : 
                _isLowPlateText = "저상 버스: X\n"

				_text += _busNumText + _leftTimeText + _leftSeatText + _isLowPlateText + _vehicleNumText
			end
			_text.chomp!

			@msg = {
				message: {
					text: _text
				},
				keyboard: {
					type: "buttons",
					buttons: _buttons
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
