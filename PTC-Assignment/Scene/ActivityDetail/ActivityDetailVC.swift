//
//  ActivityDetailVC.swift
//  PTC-Assignment
//
//  Created by Thien Huynh on 3/20/22.
//

import UIKit

class ActivityDetailVC: UITableViewController {

    @IBOutlet weak var activityTitleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    
    var viewModel: ActivityDetailVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        if let detail = viewModel?.getDetail() {
            activityTitleLabel.text = detail.activity
            typeLabel.text = detail.type
            participantsLabel.text = detail.participants
            priceLabel.text = detail.price
            linkLabel.text = detail.link
            keyLabel.text = detail.key
            accessLabel.text = detail.accessibility
        }
    }
}
