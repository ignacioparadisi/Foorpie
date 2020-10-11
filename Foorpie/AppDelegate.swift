//
//  AppDelegate.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        GIDSignIn.sharedInstance()?.clientID = "556085442737-apnkeicq085s6hul32gm2qs0qknbtgdr.apps.googleusercontent.com"
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var canOpen = false
        // Determine who sent the URL.
            let sendingAppID = options[.sourceApplication]
            print("source application = \(sendingAppID ?? "Unknown")")
            
            // Process the URL.
            if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
                let componentPath = components.path,
                let params = components.queryItems {
                if let invitationToken = params.first(where: { $0.name == "token" })?.value {
                    print("componentPath = \(componentPath)")
                    print("invitationToken = \(invitationToken)")
                    canOpen = true
                }
            }
            else {
                canOpen = false
            }
            
            
        return GIDSignIn.sharedInstance()?.handle(url) ?? canOpen
    }
}

