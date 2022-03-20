//
//  ActivitiesListVC.swift
//  PTC-Assignment
//
//  Created by Thien Huynh on 3/20/22.
//

import UIKit
import Combine

class ActivitiesListVC: UITableViewController {

    var viewModel = ActivitiesListVM()
    
    private let widthScreen = UIScreen.main.bounds.width
    private var loadingSpinner: UIActivityIndicatorView?
    var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Activities"
        setupTableView()
        bind(to: viewModel)
        viewModel.getActivitiesCombine()
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 112
        tableView.rowHeight = UITableView.automaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.handleRefreshControl), for: .valueChanged)
    }
    
    private func bind(to viewModel: ActivitiesListVM) {
        viewModel.activitiesGroups
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    self?.showError(message: err.errorMessage)}
                } receiveValue: { [weak self] _ in
                    self?.updateItems()}
            .store(in: &subscriptions)

        viewModel.loading
            .sink { [weak self] in self?.updateLoading($0) }
            .store(in: &subscriptions)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? ActivityDetailVC,
           let selectedIp = tableView.indexPathForSelectedRow,
           let activity = viewModel.getActivity(at: selectedIp) {
            let detailVM = ActivityDetailVM(activity: activity)
            vc.viewModel = detailVM
        }
    }
    
    // MARK: - Private

    private func updateItems() {
        tableView.reloadData()
    }
    
    private func updateLoading(_ loading: Bool) {
        if loading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }

    @objc func handleRefreshControl(_ sender: AnyObject) {
        viewModel.getActivitiesCombine()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.activitiesGroups.value.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: widthScreen, height: 46))
        header.backgroundColor = UIColor(named: "Background")
        let label = UILabel(frame: CGRect(x: 16, y: 8, width: widthScreen, height: 30))
        label.text = viewModel.getGroupTitle(section: section)
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor(named: "ActivityHeader")
        header.addSubview(label)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsIn(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableCell", for: indexPath) as? ActivityTableCell else {
            return UITableViewCell()
        }
        
        let activity = viewModel.dataForRow(at: indexPath)
        cell.updateCell(activity: activity.activity,
                        participants: activity.participants,
                        accessibility: activity.accessibility)
        
        return cell
    }
}
