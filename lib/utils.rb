# mixin

module Utils
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

    # 버튼을 동적으로 구성하게끔 만들어주는 메소드
	# flags배열의 요소(elem)들 리턴값을 기준으로 버튼을 생성하여
	# dynamicButtons에 버튼을 추가한다.
	def dynamic(flags, tmpBuff, dynamicButtons, dynamicText = false)
		_cnt = 0;

		flags.each_with_index do |elem, i|
			if elem
				dynamicButtons.insert(_cnt, tmpBuff[i])
				dynamicText.replace("식당을 선택해주세요!") if dynamicText
				_cnt += 1
			end
			i += 1
		end
		return dynamicButtons
    end

    def foodInfo id
        _retStr = ''
        _path = File.expand_path('..', File.dirname(__FILE__)) + '/scheduler/food/' + id

        case id

        when 'stuFoodCourt'
            lines = IO.readlines(_path, 'r')
            lines.each do |line|
                _retStr += line
            end

            return _retStr.empty? ? false : _retStr

        when 'dormIsOpen', 'facuIsOpen'
            lines = IO.readlines(_path, 'r')
            lines.each do |line|
                _retStr += line
            end

            return _retStr == 'false' ? false : true

        else
            lines = IO.readlines(_path, 'r')
            lines.each do |line|
                _retStr += line
            end

            return _retStr == 'false' ? false : _retStr
        end
    end
end