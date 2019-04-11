//
//  TestJSON.swift
//  SleepstaTests
//
//  Created by Dillon McElhinney on 4/11/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

let validDailyDataJSON = """
[
    {
    "id": 316,
    "user_id": 2,
    "sleeptime": 1554961612,
    "waketime": 1554986418,
    "qos_score": 97,
    "night_data": [
        { "y": 13.931479655982312, "x": 1554962212 },
        { "y": 6.550707403259974, "x": 1554962812 },
        { "y": 9.276068102568392, "x": 1554963412 },
        { "y": 6.288401164114474, "x": 1554964012 },
        { "y": 5.781329621250432, "x": 1554964612 },
        { "y": 3.9044178413848076, "x": 1554965212 },
        { "y": 6.409300923968359, "x": 1554965812 },
        { "y": 3.14953676238656, "x": 1554966412 },
        { "y": 3.7225060700438912, "x": 1554967012 },
        { "y": 3.5280606523156153, "x": 1554967612 },
        { "y": 2.662228504816691, "x": 1554968212 },
        { "y": 5.35191015650829, "x": 1554968812 },
        { "y": 4.115857817232607, "x": 1554969412 },
        { "y": 3.905943669378756, "x": 1554970012 },
        { "y": 2.1513876666625356, "x": 1554970612 },
        { "y": 4.4734033793210966, "x": 1554971212 },
        { "y": 5.232357186575736, "x": 1554971812 },
        { "y": 3.681149158626801, "x": 1554972412 },
        { "y": 4.559557532270749, "x": 1554973012 },
        { "y": 3.864844178160033, "x": 1554973612 },
        { "y": 4.024209556480243, "x": 1554974212 },
        { "y": 3.530093438923358, "x": 1554974812 },
        { "y": 6.26266323029994, "x": 1554975412 },
        { "y": 3.973786547780038, "x": 1554976012 },
        { "y": 5.839631659289199, "x": 1554976612 },
        { "y": 5.336966767907146, "x": 1554977212 },
        { "y": 8.286157608342657, "x": 1554977812 },
        { "y": 7.056102077166248, "x": 1554978412 },
        { "y": 7.109518085916841, "x": 1554979012 },
        { "y": 7.490393288433555, "x": 1554979612 },
        { "y": 7.373481112221872, "x": 1554980212 },
        { "y": 8.039114122589424, "x": 1554980812 },
        { "y": 7.798466682434085, "x": 1554981412 },
        { "y": 8.004129399855938, "x": 1554982012 },
        { "y": 7.133938218156496, "x": 1554982612 },
        { "y": 6.9072251170873615, "x": 1554983212 },
        { "y": 6.433782314260799, "x": 1554983812 },
        { "y": 7.87225493292014, "x": 1554984412 },
        { "y": 9.867542023460079, "x": 1554985012 },
        { "y": 11.518358796834962, "x": 1554985612 },
        { "y": 11.985195140043901, "x": 1554986212 }
    ],
    "sleep_notes": "I slept pretty well. I think I woke up once in the middle of the night. "
    }
]
""".data(using: .utf8)!

// Missing closing "]" and "e" in "waketime"
let invalidDailyDataJSON = """
[
    {
    "id": 316,
    "user_id": 2,
    "sleeptime": 1554961612,
    "waktime": 1554986418,
    "qos_score": 97,
    "night_data": [
        { "motion": 13.931479655982312, "timestamp": 1554962212 },
        { "motion": 6.550707403259974, "timestamp": 1554962812 },
        { "motion": 9.276068102568392, "timestamp": 1554963412 },
        { "motion": 6.288401164114474, "timestamp": 1554964012 },
        { "motion": 5.781329621250432, "timestamp": 1554964612 },
        { "motion": 3.9044178413848076, "timestamp": 1554965212 },
        { "motion": 6.409300923968359, "timestamp": 1554965812 },
        { "motion": 3.14953676238656, "timestamp": 1554966412 },
        { "motion": 3.7225060700438912, "timestamp": 1554967012 },
        { "motion": 3.5280606523156153, "timestamp": 1554967612 },
        { "motion": 2.662228504816691, "timestamp": 1554968212 },
        { "motion": 5.35191015650829, "timestamp": 1554968812 },
        { "motion": 4.115857817232607, "timestamp": 1554969412 },
        { "motion": 3.905943669378756, "timestamp": 1554970012 },
        { "motion": 2.1513876666625356, "timestamp": 1554970612 },
        { "motion": 4.4734033793210966, "timestamp": 1554971212 },
        { "motion": 5.232357186575736, "timestamp": 1554971812 },
        { "motion": 3.681149158626801, "timestamp": 1554972412 },
        { "motion": 4.559557532270749, "timestamp": 1554973012 },
        { "motion": 3.864844178160033, "timestamp": 1554973612 },
        { "motion": 4.024209556480243, "timestamp": 1554974212 },
        { "motion": 3.530093438923358, "timestamp": 1554974812 },
        { "motion": 6.26266323029994, "timestamp": 1554975412 },
        { "motion": 3.973786547780038, "timestamp": 1554976012 },
        { "motion": 5.839631659289199, "timestamp": 1554976612 },
        { "motion": 5.336966767907146, "timestamp": 1554977212 },
        { "motion": 8.286157608342657, "timestamp": 1554977812 },
        { "motion": 7.056102077166248, "timestamp": 1554978412 },
        { "motion": 7.109518085916841, "timestamp": 1554979012 },
        { "motion": 7.490393288433555, "timestamp": 1554979612 },
        { "motion": 7.373481112221872, "timestamp": 1554980212 },
        { "motion": 8.039114122589424, "timestamp": 1554980812 },
        { "motion": 7.798466682434085, "timestamp": 1554981412 },
        { "motion": 8.004129399855938, "timestamp": 1554982012 },
        { "motion": 7.133938218156496, "timestamp": 1554982612 },
        { "motion": 6.9072251170873615, "timestamp": 1554983212 },
        { "motion": 6.433782314260799, "timestamp": 1554983812 },
        { "motion": 7.87225493292014, "timestamp": 1554984412 },
        { "motion": 9.867542023460079, "timestamp": 1554985012 },
        { "motion": 11.518358796834962, "timestamp": 1554985612 },
        { "motion": 11.985195140043901, "timestamp": 1554986212 }
    ],
    "sleep_notes": "I slept pretty well. I think I woke up once in the middle of the night. "
    }

""".data(using: .utf8)!