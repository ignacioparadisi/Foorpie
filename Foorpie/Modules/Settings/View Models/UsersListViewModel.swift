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
    
    func section(for indexPath: IndexPath) -> Section? {
        guard let section = Section(rawValue: indexPath.section) else { return nil }
        return section
    }
}

extension UsersListViewModel: UIActivityItemSource {
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "Invitation URL"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        guard let invitationURL = URLManager.appInvitationURL() else { return nil }
        return invitationURL
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        guard let companyName = UserDefaults.standard.company?.name else { return "" }
        return "Join \(companyName) at Foorpie"
    }
    
}
