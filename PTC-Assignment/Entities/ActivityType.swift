//
//  ActivityType.swift
//  PTC-Assignment
//
//  Created by Thien Huynh on 3/19/22.
//

import Foundation

enum ActivityType: String, CaseIterable, Codable {
    case education = "education"
    case recreational = "recreational"
    case social = "social"
    case diy = "diy"
    case charity = "charity"
    case cooking = "cooking"
    case relaxation = "relaxation"
    case music = "music"
    case busywork = "busywork"
}
