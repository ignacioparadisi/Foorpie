//
//  UsersListViewModel.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/11/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class UsersListViewModel: NSObject {
    enum Section: Int {
        case invite
        case users
    }
    
    var didCreateInvitation: ((Error?) -> Void)?
    var didFetchUsers: ((Error?) -> Void)?
    private var invitation: Invitation?
    private(set) var users: [UserViewModel] = []
    
    init(users: [User]) {
        self.users = users.map { UserViewModel(user: $0) }
    }
    
    func section(for indexPath: IndexPath) -> Section? {
        guard let section = Section(rawValue: indexPath.section) else { return nil }
        return section
    }
    
    func createInvitation() {
        UserAPIManager.shared.createInvitation { [weak self] result in
            switch result {
            case .success(let invitation):
                self?.invitation = invitation
                self?.didCreateInvitation?(nil)
            case .failure(let error):
                print(error)
                self?.didCreateInvitation?(error)
            }
        }
    }
}

extension UsersListViewModel: UIActivityItemSource {
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "Invitation URL"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        guard let string = invitation?.urlString, let url = URL(string: string) else { return nil }
        return url
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        guard let companyName = UserDefaults.standard.company?.name else { return "" }
        return "Join \(companyName) at Foorpie"
    }
    
}
