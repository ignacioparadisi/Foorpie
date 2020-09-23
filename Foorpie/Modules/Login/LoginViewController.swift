//
//  LoginViewController.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/21/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: GIDSignInDelegate {
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
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        guard let email = user.profile.email else { return }
        let user = User(email: email, fullName: fullName, googleToken: idToken)
        PersistenceManagerFactory.userPersistenceManager.login(user: user) { result in
            print(result)
            switch result {
            case .success(let user):
                let window = UIApplication.shared.windows.first
                window?.setRootViewController(MainTabBarController())
            case .failure(let error):
                let alert = UIAlertController(title: "Inicio de sesión fallido", message: "Hubo un error al iniciar sesión.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                alert.addAction(okAction)
                GIDSignIn.sharedInstance()?.signOut()
                self.present(alert, animated: true)
            }
        }

        
    }
}
