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
            name: _lumberroomAddr + '/stuFoodCourt',
            contents: _stuFoodCourt
        },  
        dormBreakfast: {
            name: _lumberroomAddr + '/dormBreakfast',
            contents: _dormFoodCourt[:breakfast]
        },
        dormLunch: {
            name: _lumberroomAddr + '/dormLunch',
            contents: _dormFoodCourt[:lunch]
        },
        dormDinner: {
            name: _lumberroomAddr + '/dormDinner',
            contents: _dormFoodCourt[:dinner]
        },
        dormIsOpen: {
            name: _lumberroomAddr + '/dormIsOpen',
            content: _dormFoodCourt[:isOpen]
        },
        facuLunch: {
            name: _lumberroomAddr + '/facuLunch',
            contents: _facuFoodCourt[:lunch]
        },
        facuDinner: {
            name: _lumberroomAddr + '/facuDinner',
            contents: _facuFoodCourt[:dinner]
        },
        facuIsOpen: {
            name: _lumberroomAddr + '/facuIsOpen',
            contents: _facuFoodCourt[:isOpen]
        }
    }

    FileUtils.mkdir_p(_lumberroomAddr)

    _files.each do |key, value|
        _fs = File.new(value[:name], 'w')
        _fs.syswrite(value[:contents])
    end
end

theif