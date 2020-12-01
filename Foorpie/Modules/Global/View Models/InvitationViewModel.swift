//
//  InvitationViewModel.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/12/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import Combine

class InvitationViewModel {
    
    private let token: String
    private var invitation: Invitation?
    var didFetchInvitation: ((Error?) -> Void)?
    var didAcceptInvitation: ((Error?) -> Void)?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isAcceptingInvitation: Bool = false
    
    var companyName: String {
        return invitation?.company?.name ?? LocalizedStrings.Title.company
    }
    
    init(token: String) {
        self.token = token
    }
    
    func fetchInvitationInformation() {
        if isLoading { return }
        isLoading = true
        APIManagerFactory.userAPIManager.fetchInvitationInformation(token: token) { [weak self] result in
            switch result {
            case .success(let invitation):
                self?.invitation = invitation
                self?.didFetchInvitation?(nil)
            case .failure(let error):
                print(error)
                self?.didFetchInvitation?(error)
            }
            self?.isLoading = false
        }
    }
    
    func acceptInvitation() {
        guard let invitation = invitation else { return }
        if isAcceptingInvitation { return }
        isAcceptingInvitation = true
        invitation.token = token
        APIManagerFactory.userAPIManager.acceptInvitation(invitation: invitation) { [weak self] result in
            self?.isAcceptingInvitation = false
            switch result {
            case .success:
                self?.didAcceptInvitation?(nil)
            case .failure(let error):
                self?.didAcceptInvitation?(error)
            }
        }
    }
}
