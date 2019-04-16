//
//  SampleDailyData.swift
//  SleepstaTests
//
//  Created by Dillon McElhinney on 4/16/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
@testable import Sleepsta

let motionData: [MotionData] = [
    MotionData(motion: 4.8209352900584545, timestamp: 1553665161),
    MotionData(motion: 3.1971837262312556, timestamp: 1553665761),
    MotionData(motion: 3.5040233644346386, timestamp: 1553666361),
    MotionData(motion: 3.6783727121849839, timestamp: 1553666961),
    MotionData(motion: 8.1440943626066108, timestamp: 1553667561),
    MotionData(motion: 2.5747798234224293, timestamp: 1553668161),
    MotionData(motion: 3.2866822468737746, timestamp: 1553668761),
    MotionData(motion: 2.7048958236972472, timestamp: 1553669361),
    MotionData(motion: 1.5174417376518263, timestamp: 1553669961),
    MotionData(motion: 2.5681548232833543, timestamp: 1553670561),
    MotionData(motion: 1.6186708800494678, timestamp: 1553671161),
    MotionData(motion: 3.2903311905761548, timestamp: 1553671761),
    MotionData(motion: 1.6270990418891122, timestamp: 1553672361),
    MotionData(motion: 1.8558466233313068, timestamp: 1553672961),
    MotionData(motion: 1.9191882677376253, timestamp: 1553673561),
    MotionData(motion: 1.5518835050364332, timestamp: 1553674161),
    MotionData(motion: 1.7805493200818712, timestamp: 1553674761),
    MotionData(motion: 2.0621156928439932, timestamp: 1553675361),
    MotionData(motion: 1.5473646352688479, timestamp: 1553675961),
    MotionData(motion: 2.6905533738434288, timestamp: 1553676561),
    MotionData(motion: 1.6631210351983694, timestamp: 1553677161),
    MotionData(motion: 2.0448710451523448, timestamp: 1553677761),
    MotionData(motion: 1.9186105762918796, timestamp: 1553678361),
    MotionData(motion: 2.9101491579165032, timestamp: 1553678961),
    MotionData(motion: 2.0843224726617332, timestamp: 1553679561),
    MotionData(motion: 3.1402975929280128, timestamp: 1553680161),
    MotionData(motion: 2.4249337057272592, timestamp: 1553680761),
    MotionData(motion: 2.4333878042797251, timestamp: 1553681361),
    MotionData(motion: 4.1488268394023207, timestamp: 1553681961),
    MotionData(motion: 2.7872679295639244, timestamp: 1553682561),
    MotionData(motion: 3.649584077050286, timestamp: 1553683161),
    MotionData(motion: 5.347974315782394, timestamp: 1553683761),
    MotionData(motion: 6.328985128800071, timestamp: 1553684361),
    MotionData(motion: 8.3805624845127277, timestamp: 1553684961),
    MotionData(motion: 8.1185336134086064, timestamp: 1553685561),
    MotionData(motion: 7.4736218500882423, timestamp: 1553686161),
    MotionData(motion: 6.7529103897511924, timestamp: 1553686761),
    MotionData(motion: 5.6358410793046106, timestamp: 1553687361),
    MotionData(motion: 5.8806757879753913, timestamp: 1553687961),
    MotionData(motion: 5.65740215641757, timestamp: 1553688561),
    MotionData(motion: 5.697561165566246, timestamp: 1553689161)
]

func sampleDailyData() -> DailyData {
    let dailyData = DailyData(userID: 1)
    dailyData.bedTime = 1553664561
    dailyData.wakeTime = 1553689161
    dailyData.sleepNotes = "This is a sample note."
    dailyData.nightData = motionData
    
    return dailyData
}
