//
//  ActivityTableCell.swift
//  PTC-Assignment
//
//  Created by Thien Huynh on 3/20/22.
//

import UIKit

class ActivityTableCell: UITableViewCell {

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add shadow for wrapper view
        wrapperView.layer.cornerRadius = 8
        wrapperView.layer.shadowOffset = CGSize(width: 1, height: 1)
        wrapperView.layer.shadowRadius = 4
        wrapperView.layer.shadowOpacity = 0.25
    }

    func updateCell(activity: String, participants: String, accessibility: String) {
        activityLabel.text = activity
        participantsLabel.text = "Participants: \(participants)"
        accessLabel.text = "Accessibility: \(accessibility)"
    }

}
