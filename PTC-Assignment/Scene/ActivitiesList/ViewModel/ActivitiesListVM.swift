//
//  ActivitiesListVM.swift
//  PTC-Assignment
//
//  Created by Thien Huynh on 3/20/22.
//

import UIKit
import Combine

typealias ActivitiesGroup = [ActivityType:[Activity]]

class ActivitiesListVM {

    var activitiesGroups = CurrentValueSubject<ActivitiesGroup, APIError>([:])
    var loading = CurrentValueSubject<Bool, Never>(false)
    var subscriptions: Set<AnyCancellable> = []
    
    private var allTypes = ActivityType.allCases
    
    deinit {
        subscriptions.forEach { $0.cancel() }
    }
    
    func getActivitiesCombine() {
        activitiesGroups.value = [:]
        self.loading.value = true
        let requestArray = ActivityType.allCases
                                        .flatMap { Array(repeating: $0, count: 5) }

        Just(requestArray)
            .flatMap {types -> Publishers.MergeMany<AnyPublisher<Activity, APIError>> in
                let tasks = types.map { (type) -> AnyPublisher<Activity, APIError> in
                    return APIService.execute(endpoint: .getActivity(activityType: type.rawValue), decodingType: Activity.self)
                }
                return Publishers.MergeMany(tasks)}
            .collect()
            .receive(on: DispatchQueue.main)
            .sink{ completion in
                self.loading.value = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.activitiesGroups.send(completion: .failure(error))
                }
            } receiveValue: { activities in
                var groups = ActivitiesGroup()
                activities.forEach {
                    let type = $0.type
                    if groups[type] != nil {
                        groups[type]!.append($0)
                        groups[type]!.sort(by: {($0.accessibility ?? 0) < ($1.accessibility ?? 0)})
                    } else {
                        groups[type] = [$0]
                    }
                }
                self.activitiesGroups.value = groups
            }.store(in: &subscriptions)
    }
    
    
    func numberOfItemsIn(section: Int) -> Int {
        return getGroup(at: section).count
    }
    
    func getGroupTitle(section: Int) -> String {
        return allTypes[section].rawValue.capitalized
    }
    
    func dataForRow(at indexPath: IndexPath) -> (activity: String, participants: String, accessibility: String) {
        let group = getGroup(at: indexPath.section)
        guard group.count > indexPath.row else { return ("", "", "") }
        let activity = group[indexPath.row]
        return (activity.activity ?? "",
                "\(activity.participants ?? 0)",
                "\(activity.accessibility ?? 0)")
    }
    
    private func getActivity(at indexPath: IndexPath) -> Activity? {
        let group = getGroup(at: indexPath.section)
        guard group.count > indexPath.row else { return nil }
        return group[indexPath.row]
    }
    
    private func getGroup(at section: Int) -> [Activity] {
        return activitiesGroups.value[allTypes[section]] ?? []
    }
}
