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
end