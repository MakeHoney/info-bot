require 'open-uri'
require 'nokogiri'
require 'data_set'
require 'utils'
# Hash prettifier
require 'pp'

module Crawler
    class SchoolFood
        extend Utils

        _url = 'http://www.ajou.ac.kr/main/life/food.jsp'
        _html = fixHtml(open(_url).read)
        @page = Nokogiri::HTML(_html)

		def self.studentFoodCourt
			_retStr = ''
			_flag = 0
			@page.css('table.ajou_table')[0].css('td.no_right li').each do |li|
				_retStr += "\n" if partition(li.text) && _flag != 0
				_retStr += "#{li.text}\n"
				_flag += 1
			end

			_retStr.chomp!

			if _retStr.empty?
				return false
			else
				return _retStr
			end
		end

		def self.dormFoodCourt
			_retHash = {
				breakfast: '',
				lunch: '',
				dinner: '',
				snack: '',
				isOpen: false
			}

			_keys = _retHash.keys

			_set = ['아침', '점심', '저녁', '분식']
			_cnt = 0

			_set.length.times do |i|
				# xpath는 index가 1부터 시작한다.
				_flag = 0
				_length_for_exption =
				@page.xpath("//table[@class='ajou_table'][2]
					//td[contains(text(), \"#{_set[i]}\")]").length

				if _length_for_exption == 0
					_retHash[_keys[i]] = false
					_cnt -= 1
				else
					@page.css('table.ajou_table')[1].
					css('td.no_right')[_cnt + 1].		# 아침 점심 저녁 선택자
					css('li').each do |li|
						_retHash[_keys[i]] += "\n" if partition(li.text) && _flag != 0
						_retHash[_keys[i]] += "#{li.text}\n"
						_flag += 1
					end

				end

				_cnt += 1
				_retHash[:isOpen] = true if _retHash[_keys[i]]
				_retHash[_keys[i]].chomp! if _retHash[_keys[i]]

			end
			return _retHash
		end

		def self.facultyFoodCourt
			_retHash = {
				lunch: '',
				dinner: '',
				isOpen: false
			}

			_keys = _retHash.keys

			_set = ['점심', '저녁']
			_cnt = 0

			_set.length.times do |i|

				_length_for_exption =
				@page.xpath("//table[@class='ajou_table'][3]
					//td[contains(text(), \"#{_set[i]}\")]").length

				if _length_for_exption == 0
					_retHash[_keys[i]] = false
				else
					_retHash[_keys[i]] += "※ <중식 - 5,000원>\n" if i == 0
					_retHash[_keys[i]] += "※ <석식 - 5,000원>\n" unless i == 0
					@page.css('table.ajou_table')[2].
					css('td.no_right')[_cnt + 1].
					css('li').each do |li|
						_retHash[_keys[i]] += "#{li.text}\n"
					end
					_retHash[_keys[i]] += "\n*운영시간 : 11:00 ~ 14:00\n" if i == 0
					_retHash[_keys[i]] += "\n*운영시간 : 17:00 ~ 19:00\n" unless i == 0
				end

				_cnt += 1
				_retHash[:isOpen] = true if _retHash[_keys[i]]
				_retHash[_keys[i]].chomp! if _retHash[_keys[i]]

			end

			return _retHash
		end
    end
    
    class Vacancy
        @pages = []; @room = ['C1', 'D1']
        def self.printVacancy
            @pages.clear
            @room.length.times do |i|
                _url = "http://u-campus.ajou.ac.kr/ltms/rmstatus/vew.rmstatus?bd_code=JL&rm_code=JL0#{@room[i]}"
                _html = open(_url).read
                @pages << Nokogiri::HTML(_html)
            end

			_retStr = ['', '']
			_retStr.length.times do |i|	# C1, D1
				_tmp = @pages[i].css('td[valign="middle"]')[1].text.split
				_retStr[i] += "◆ #{@room[i]} 열람실의 이용 현황\n"
				_retStr[i] += "  * 남은 자리 : #{_tmp[6]}\n"
				_retStr[i] += "  * #{_tmp[10]} : #{_tmp[8].to_i - _tmp[6].to_i} / #{_tmp[8]} (#{_tmp[12]})"
				_retStr[i].chomp! if _retStr[i]
			end
			return _retStr	# retStr이 empty일 때 예외처리하기
		end
	end

    class Transport
        @stations = DataSet::ForCrawler.StationInfoForTransport
        @pages = {
            entrance_1: '',
            entrance_2: '',
            entrance_3: '',
            entrance_4: '',
            highschool_1: '',
            highschool_2: ''
        }

        @stations.each do |station, value|
            if station != :busNum
                _url = "http://www.gbis.go.kr/gbis2014/openAPI.action?cmd=busarrivalservicestation&serviceKey=1234567890&stationId=#{value[:id]}"
                _html = open(_url).read
                @pages[station] = Nokogiri::XML(_html)
            end
        end

		def self.busesInfo(spotSymbol)
			_buses = {}
			_busInformations = {
				number: '', 				# 버스 번호
				leftTime: '',				# 남은 시간
				seats: '',					# 남은 좌석
				isLowPlate: '',		    	# 저상 여부
				vehicleNum: ''		    	# 차량 번호
			}

			@pages[spotSymbol].css('busArrivalList').each do |busDesc|
				tmpKey = @stations[:busNum][busDesc.css('routeId').text]
				_buses[tmpKey] = _busInformations.dup
				_buses[tmpKey][:number] = "* #{tmpKey}번 버스 *"
				_buses[tmpKey][:leftTime] = busDesc.css('predictTime1').text
				_buses[tmpKey][:seats] = busDesc.css('remainSeatCnt1').text
				_buses[tmpKey][:isLowPlate] = busDesc.css('lowPlate1').text
				_buses[tmpKey][:vehicleNum] = busDesc.css('plateNo1').text
			end

			return _buses
		end
	end

	class Notice
        @codeForNotice = DataSet::ForCrawler.CodeForNotice
		attr_accessor :totalNum
        
        # Notice class도 single tone pattern이 적용 가능할지 고민하기
		def initialize(key)
			@home = 'http://www.ajou.ac.kr'
			_notice = @home + '/new/ajou/notice.jsp'

			if(key.eql?("home"))
				_url = _notice
			else
				_url = _notice + "?search:search_category:category=#{@codeForNotice[key]}"
			end
			# Ruby에서는 생성자 오버로딩을 지원하지 않는다.
			# 때문에 조건문을 통해서 처리하였다.
			@page = Nokogiri::HTML(open(_url).read)
			@totalNum = numOfPost
		end

		def numOfPost
			_endPageUrl = @home + @page.css('.pager_wrap a[title="끝"]')[0]['href'].to_s
			# a 태그 중에 title의 속성이 '끝'인 라인을 불러온다.
			# @page.css('div.pager_wrap a[title="끝"]')는 배열로 저장이 되기 때문에
			# [0]와 같이 인덱스를 명시해줘야 한다. ['href']는 a 태그의 href값 참조하게 해준다.
			_html = open(_endPageUrl)
			_endPage = Nokogiri::HTML(_html)

			_part1 = _endPageUrl.split('offset=')[1].to_i
			_part2 = _endPage.css('.list_wrap a').length
			_entireNumOfPost = _part1 + _part2
			return _entireNumOfPost
		end

		def printNotice(userNumOfNotice)
			# userNumOfNotice : 유저 개개인이 printNotice 재실행 전까지 본 공지글의 수
			_newNotice = @totalNum - userNumOfNotice
			puts "총 #{_newNotice}개의 새로운 공지가 있습니다."
			puts "총 게시물의 수 : #{@totalNum}"

			_iter = _newNotice > 10 ? 10 : _newNotice
			# 새로운 게시물이 10개 이상일 경우 최대 10개만 보여준다.
			_iter.times do |i|
				puts @page.css('.list_wrap a')[i].text
			end
		end
	end
end
