# mixin
module DataSet
    class ForController
        class << self
            attr_accessor :ButtonInfoForTransport
        end
        
        @ButtonInfoForTransport = {
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

    end

    class ForCrawler
        class << self
            attr_accessor :StationInfoForTransport,
                          :CodeForNotice
        end
        
        @StationInfoForTransport = {
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

        @CodeForNotice = {
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
    end
end