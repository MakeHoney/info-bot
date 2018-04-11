require 'open-uri'
require 'nokogiri'

	# f = File.open('test.txt', 'w')
	# f.puts @html #	파일 입출력을 이용하여 문서 디버깅
	module Crawler
		class SchoolFood
			# @page
		def initialize
			url = 'http://www.ajou.ac.kr/kr/life/food.jsp'
			html = fixHtml(open(url).read)
			# open(url)은 오브젝트명을 반환 open(url).read는 html문서 반환
			@page = Nokogiri::HTML(html)
		end

		def fixHtml(html)
			html.gsub!(/<[가-힣]/) {|s| s = '※ &lt;' + s[1]}
			html.gsub!(/[가-힣]>/) {|s| s = s[0] + '&gt;'}
		end
		
		def partition(string)
			if string.include?("<") || string.include?(">") || string.include?("운영")
				return true
			else
				return false
			end
		end

		def studentFoodCourt
			retStr = ""
			flag = 0
			@page.css('table.ajou_table')[0].css('td.no_right li').each do |li|
				retStr += "\n" if partition(li.text) && flag != 0
				retStr += "#{li.text}\n"
				flag += 1
				# puts li.text
			end
			
			retStr.chomp!
			if retStr.empty?
				return "등록된 식단이 없습니다."
			else
				return retStr
			end
		end

		def dormFoodCourt
			retStr = ['', '', '', '']

			4.times do |i|
				flag = 0
				@page.css('table.ajou_table')[1].
				css('td.no_right')[i + 1].		# 아침 점심 저녁 선택자
				css('li').each do |li|
					retStr[i] += "\n" if partition(li.text) && flag != 0
					retStr[i] += "#{li.text}\n"
					flag += 1
				end	
				retStr[i].chomp!
			end
			return retStr
		end

		def facultyFoodCourt	# 식단이 없을 시 예외처리 추가 
			retStr = ['', '']

			2.times do |i|
				@page.css('table.ajou_table')[2].
				css('td.no_right')[i + 1].		
				css('li').each do |li|
					retStr[i] += "#{li.text}\n"
				end	
				retStr[i].chomp!
			end
			return retStr
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
			2.times do |i|
				url = "http://u-campus.ajou.ac.kr/ltms/rmstatus/vew.rmstatus?bd_code=JL&rm_code=JL0#{@room[i]}"
				html = open(url).read
				@pages << Nokogiri::HTML(html)
			end
		end
		def printVacancy
			retStr = ['', '']
			2.times do |i|	# C1, D1
			tmp = @pages[i].css('td[valign="middle"]')[1].text.split
				retStr[i] += "◆ #{@room[i]} 열람실의 이용 현황\n\n"
				retStr[i] += "  * 남은 자리 : #{tmp[6]}\n"
				retStr[i] += "  * #{tmp[10]} : #{tmp[8].to_i - tmp[6].to_i} / #{tmp[8]} (#{tmp[12]})"
			end
			return retStr
		end
	end
end