//
//  MainTabBarController.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import GoogleSignIn

class MainTabBarController: UITabBarController {
    // MARK: Properties
    /// View controller for listing orders
    private let orderSplitViewController = OrderSplitViewController()
    /// View controller for listing recipes
    private let menuSplitViewController = MenuSplitViewController()
    private let settingsSplitViewController = AccountSplitViewController()
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        orderSplitViewController.tabBarItem = UITabBarItem(title: Localizable.Title.orders, image: .trayFull, selectedImage: .trayFullFill)
        menuSplitViewController.tabBarItem = UITabBarItem(title: Localizable.Title.recipes, image: .docPlaintext, selectedImage: .docPlaintextFill)
        settingsSplitViewController.tabBarItem = UITabBarItem(title: Localizable.Title.profile, image: .personCropCircle, selectedImage: .personCropCircleFill)
        menuSplitViewController.preferredDisplayMode = .allVisible
        viewControllers = [
            orderSplitViewController,
            menuSplitViewController,
            settingsSplitViewController
        ]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !(GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false) {
            let loginViewController = LoginViewController()
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: false)
        } else {
            GIDSignIn.sharedInstance()?.delegate = self
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        }
    }
}

extension MainTabBarController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        guard let email = user.profile.email else { return }
        let user = User(email: email, fullName: fullName, googleToken: idToken)
        PersistenceManagerFactory.userPersistenceManager.login(user: user) { result in
            print(result)
            switch result {
            case .success(let user):
                break
            case .failure(let error):
                GIDSignIn.sharedInstance()?.signOut()
            }
        }
    }
}

