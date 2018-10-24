# mixin

module Utils
    
    def fixHtml html
        html.gsub!(/<[가-힣]/) {|s| s = '&lt;' + s[1]}
        html.gsub!(/[가-힣]>/) {|s| s = s[0] + '&gt;'}
        return html
    end

    # Method for arranging a string partially
    def partition string
        if (string.include?("<") || string.include?(">") ||
            (string.include?("운영") && string.include?("시간")) ||
            string.include?("Burger")) # && !string.include?("택") 을 넣을까..?
            return true
        else
            return false
        end
    end

    # Method for creating dynamic button
	def dynamic flags, tmpBuff, dynamicButtons, dynamicText = false
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

    # Method that read crawling data from food dir and see if the data is valid or not
    def foodInfo id
        _retStr = ''
        _path = File.expand_path('..', File.dirname(__FILE__)) + '/scheduler/food/' + id

        case id
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