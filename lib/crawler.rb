require 'open-uri'
require 'nokogiri'

# Hash prettifier
require 'pp'

module Crawler
	class SchoolFood
		def initialize
			url = 'http://www.ajou.ac.kr/kr/life/food.jsp'

			# open(url)은 오브젝트명을 반환 open(url).read는 html문서 반환
			html = fixHtml(open(url).read)

			@page = Nokogiri::HTML(html)
		end

		def fixHtml(html)
			html.gsub!(/<[가-힣]/) {|s| s = '&lt;' + s[1]}
			html.gsub!(/[가-힣]>/) {|s| s = s[0] + '&gt;'}
			return html
		end

		def partition(string)
			if (string.include?("<") || string.include?(">") ||
				(string.include?("운영") && string.include?("시간")) ||
				string.include?("Burger")) # && !string.include?("택") 을 넣을까..?
				return true
			else
				return false
			end
		end


		def studentFoodCourt
			retStr = ''
			flag = 0
			@page.css('table.ajou_table')[0].css('td.no_right li').each do |li|
				retStr += "\n" if partition(li.text) && flag != 0
				retStr += "#{li.text}\n"
				flag += 1
				# puts li.text
			end

			retStr.chomp!

			if retStr.empty?
				return false
			else
				return retStr
			end
		end

		def dormFoodCourt
			retHash = {
				breakfast: '',
				lunch: '',
				dinner: '',
				snack: '',
				isOpen: false
			}

			keys = retHash.keys

			set = ['아침', '점심', '저녁', '분식']
			cnt = 0

			set.length.times do |i|
				flag = 0
				# 식단이 등록되어 있지 않은 경우 예외처리 => 변수 cnt와 xpath 이용
				# xpath는 index가 1부터 시작한다.
				length_for_exption =
				@page.xpath("//table[@class='ajou_table'][2]
					//td[contains(text(), \"#{set[i]}\")]").length

				if length_for_exption == 0
					retHash[keys[i]] = false
					cnt -= 1
				else
					@page.css('table.ajou_table')[1].
					css('td.no_right')[cnt + 1].		# 아침 점심 저녁 선택자
					css('li').each do |li|
						retHash[keys[i]] += "\n" if partition(li.text) && flag != 0
						retHash[keys[i]] += "#{li.text}\n"
						flag += 1
					end

				end

				cnt += 1

				# 아침, 점심, 저녁, 분식 중 하나라도 식단이 존재하면
				# retStr[4]의 값을 true로 변경한다. 다시말해서,
				# 모든 시간대의 식단이 없으면 retStr[4]의 값은 false이다.
				# facultyFoodCourt() 메소드에서도 동일 알고리즘이 쓰인다.
				retHash[:isOpen] = true if retHash[keys[i]]
				retHash[keys[i]].chomp! if retHash[keys[i]]

			end
			return retHash
		end

		def facultyFoodCourt
			retHash = {
				lunch: '',
				dinner: '',
				isOpen: false
			}

			keys = retHash.keys

			set = ['점심', '저녁']
			cnt = 0

			set.length.times do |i|

				length_for_exption =
				@page.xpath("//table[@class='ajou_table'][3]
					//td[contains(text(), \"#{set[i]}\")]").length

				if length_for_exption == 0
					retHash[keys[i]] = false
				else
					retHash[keys[i]] += "※ <중식 - 5,000원>\n" if i == 0
					retHash[keys[i]] += "※ <석식 - 5,000원>\n" unless i == 0
					@page.css('table.ajou_table')[2].
					css('td.no_right')[cnt + 1].
					css('li').each do |li|
						retHash[keys[i]] += "#{li.text}\n"
					end
					retHash[keys[i]] += "\n*운영시간 : 11:00 ~ 14:00\n" if i == 0
					retHash[keys[i]] += "\n*운영시간 : 17:00 ~ 19:00\n" unless i == 0
				end

				cnt += 1
				retHash[:isOpen] = true if retHash[keys[i]]
				retHash[keys[i]].chomp! if retHash[keys[i]]

			end

			return retHash
		end
	end

	class Notice
		attr_accessor :totalNum
		# @home; @page; @totalNum
		@@codeForNotice = {
			'schoolAffair' => '76',	# 학사
			'nonSubject' => '290',	# 비교과
			'scholarship' => '77',	# 장학
			'academic' => '78',		# 학술
			'admission' => '79',	# 입학
			'job' => '80',			# 취업
			'office' => '84',		# 사무
			'event' => '85',		# 행사
			'etc' => '86',			# 기타
			'paran' => '317'		# 파란학기제
		}

		def initialize(key)
			@home = 'http://www.ajou.ac.kr'
			notice = @home + '/new/ajou/notice.jsp'

			if(key.eql?("home"))
				url = notice
			else
				url = notice + "?search:search_category:category=#{@@codeForNotice[key]}"
			end
			# Ruby에서는 생성자 오버로딩을 지원하지 않는다.
			# 때문에 조건문을 통해서 처리하였다.
			@page = Nokogiri::HTML(open(url).read)
			@totalNum = numOfPost
		end

		def numOfPost
			endPageUrl = @home + @page.css('.pager_wrap a[title="끝"]')[0]['href'].to_s
			# a 태그 중에 title의 속성이 '끝'인 라인을 불러온다.
			# @page.css('div.pager_wrap a[title="끝"]')는 배열로 저장이 되기 때문에
			# [0]와 같이 인덱스를 명시해줘야 한다. ['href']는 a 태그의 href값 참조하게 해준다.
			html = open(endPageUrl)
			endPage = Nokogiri::HTML(html)

			part1 = endPageUrl.split('offset=')[1].to_i
			part2 = endPage.css('.list_wrap a').length
			entireNumOfPost = part1 + part2
			return entireNumOfPost
		end

		def printNotice(userNumOfNotice)
			# userNumOfNotice : 유저 개개인이 printNotice 재실행 전까지 본 공지글의 수
			newNotice = @totalNum - userNumOfNotice
			puts "총 #{newNotice}개의 새로운 공지가 있습니다."
			puts "총 게시물의 수 : #{@totalNum}"

			iter = newNotice > 10 ? 10 : newNotice
			# 새로운 게시물이 10개 이상일 경우 최대 10개만 보여준다.
			iter.times do |i|
				puts @page.css('.list_wrap a')[i].text
			end
		end
	end

	class Vacancy
		def initialize
			@pages = []; @room = ['C1', 'D1']
			@room.length.times do |i|
				url = "http://u-campus.ajou.ac.kr/ltms/rmstatus/vew.rmstatus?bd_code=JL&rm_code=JL0#{@room[i]}"
				html = open(url).read
				@pages << Nokogiri::HTML(html)
			end
		end
		def printVacancy
			retStr = ['', '']
			retStr.length.times do |i|	# C1, D1
				tmp = @pages[i].css('td[valign="middle"]')[1].text.split
				retStr[i] += "◆ #{@room[i]} 열람실의 이용 현황\n"
				retStr[i] += "  * 남은 자리 : #{tmp[6]}\n"
				retStr[i] += "  * #{tmp[10]} : #{tmp[8].to_i - tmp[6].to_i} / #{tmp[8]} (#{tmp[12]})"
				retStr[i].chomp! if retStr[i]
			end
			return retStr	# retStr이 empty일 때 예외처리하기
		end
	end

	class Transport
		@@stations = {
			entrance_1: { 						# 정문 (맥날)
				id: '203000066',
				name: '아주대 정문 (맥날)'
			},
			entrance_2: { 						# 정문 (KFC)
				id: '202000005',
				name: '아주대 정문 (KFC)'
			},
			entrance_3: { 						# 후문
				id: '202000042',
				name: '아주대 후문[0]'
			},
			entrance_4: { 						# 후문 건너편
				id: '202000041',
				name: '아주대 후문[1]'
			},
			highschool_1: { 					# 창현, 유신고1
				id: '202000039',
				name: '창현, 유신고[0]'
			},
			highschool_2: { 					# 창현, 유신고2
				id: '202000061',
				name: '창현, 유신고[1]'
			},
			busNum: {
				'200000070' => '11-1',
				'200000185' => '13-4',
				'200000211' => '18',
				'200000157' => '2-2',
				'200000053' => '20',
				'223000100' => '202',
				'200000064' => '32',
				'200000236' => '32-3',
				'200000272' => '32-4',
				'200000206' => '5-4',
				'200000231' => '54',
				'234000024' => '720-1',
				'234001608' => '720-1A',
				'234000026' => '720-2',
				'200000146' => '80',
				'200000208' => '81',
				'200000197' => '85',
				'200000199' => '88-1',
				'200000201' => '9-2',
				'200000144' => '99',
				'200000196' => '99-2',
				'200000013' => '999',
				'234000013' => '직행1007-1',
				'200000145' => '직행3002',
				'200000110' => '직행3007',
				'200000274' => '직행3008',
				'204000056' => '직행4000',
				'200000112' => '직행7000',
				'200000119' => '직행7001',
				'200000109' => '직행7002',
				'200000205' => '직행8800',
				'241004760' => '시외8862',
				'241201001' => '마을1',
				'241201003' => '마을3',
				'241201006' => '마을7'
			}
		}

		def initialize
			@pages = {
				entrance_1: '',
				entrance_2: '',
				entrance_3: '',
				entrance_4: '',
				highschool_1: '',
				highschool_2: ''
			}

			@@stations.each do |station, value|
				# puts station
				if station != :busNum
					url = "http://www.gbis.go.kr/gbis2014/openAPI.action?cmd=busarrivalservicestation&serviceKey=1234567890&stationId=#{value[:id]}"
					html = open(url).read
					@pages[station] = Nokogiri::XML(html)
				end
			end
			# pp @pages
		end

		def busesInfo(spotSymbol)
			buses = {}
			busInformations = {
				number: '', 				# 버스 번호
				leftTime: '',				# 남은 시간
				seats: '',					# 남은 좌석
				isLowPlate: '',			# 저상 여부
				vehicleNum: ''			# 차량 번호
			}

			# puts @pages[spotSymbol].css('resultMessage').text
			@pages[spotSymbol].css('busArrivalList').each do |busDesc|
				tmpKey = @@stations[:busNum][busDesc.css('routeId').text]
				buses[tmpKey] = busInformations.dup
				buses[tmpKey][:number] = "* #{tmpKey}번 버스 *"
				buses[tmpKey][:leftTime] = busDesc.css('predictTime1').text
				buses[tmpKey][:seats] = busDesc.css('remainSeatCnt1').text
				buses[tmpKey][:isLowPlate] = busDesc.css('lowPlate1').text
				buses[tmpKey][:vehicleNum] = busDesc.css('plateNo1').text
			end

			# pp buses
			return buses
		end
	end
end
