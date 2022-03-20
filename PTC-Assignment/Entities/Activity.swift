//
//  Activity.swift
//  PTC-Assignment
//
//  Created by Thien Huynh on 3/19/22.
//

import Foundation

// MARK: - Activity
struct Activity: Decodable {
    let key: String
    let activity: String?
    let type: ActivityType
    let participants: Int?
    let price: Double?
    let link: String?
    let accessibility: Double?
}
