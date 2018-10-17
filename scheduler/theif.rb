# require File.expand_path('..', File.dirname(__FILE__)) + '/lib/crawler'
require_relative '../lib/crawler'
require 'fileutils'

def theif
    _schoolFood = Crawler::SchoolFood.new
    _stuFoodCourt = _schoolFood.studentFoodCourt
    _dormFoodCourt = _schoolFood.dormFoodCourt
    _facuFoodCourt = _schoolFood.facultyFoodCourt
    _lumberroomAddr = File.expand_path(File.dirname(__FILE__)) + '/food'
    
    _files = {
        stuFoodCourt: {
            name: _lumberroomAddr + '/stuFoodCourt.txt',
            contents: _stuFoodCourt
        },  
        dormBreakfast: {
            name: _lumberroomAddr + '/dormBreakfast.txt',
            contents: _dormFoodCourt[:breakfast]
        },
        dormLunch: {
            name: _lumberroomAddr + '/dormLunch.txt',
            contents: _dormFoodCourt[:lunch]
        },
        dormDinner: {
            name: _lumberroomAddr + '/dormDinner.txt',
            contents: _dormFoodCourt[:dinner]
        },
        facuLunch: {
            name: _lumberroomAddr + '/facuLunch.txt',
            contents: _facuFoodCourt[:lunch]
        },
        facuDinner: {
            name: _lumberroomAddr + '/facuDinner.txt',
            contents: _facuFoodCourt[:dinner]
        }
    }

    FileUtils.mkdir_p(_lumberroomAddr)

    _files.each do |key, value|
        _fs = File.new(value[:name], 'w')
        _fs.syswrite(value[:contents])
    end
end

theif