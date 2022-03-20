//
//  ActivityDetailVM.swift
//  PTC-Assignment
//
//  Created by Thien Huynh on 3/20/22.
//

import Foundation

class ActivityDetailVM {
    
    let activity: Activity
    
    init(activity: Activity) {
        self.activity = activity
    }
    
    func getDetail() -> (activity: String, type: String,
                         participants: String, price: String,
                         link: String, key: String,
                         accessibility: String) {
        return (activity.activity ?? "",
                "Type: \(activity.type.rawValue.capitalized)",
                "Participants: \(activity.participants ?? 0)",
                "Price: \(activity.price ?? 0)",
                "Link: \(activity.link ?? "")",
                "Key: \(activity.key)",
                "Accessibility: \(activity.accessibility ?? 0)")
    }
}
