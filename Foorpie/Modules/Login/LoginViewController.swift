//
//  LoginViewController.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/21/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

class LoadingView: UIView {
    
    // MARK: Properties
    private let activityIndicatorView = UIActivityIndicatorView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    private var superviewInstance: UIView?
    
    // MARK: Initializers
    init(title: String? = nil) {
        super.init(frame: .zero)
        titleLabel.text = title?.uppercased()
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        let contentView = UIView()
        contentView.backgroundColor = .clear
        
        addSubview(contentView)
        contentView.addSubview(activityIndicatorView)
        contentView.addSubview(titleLabel)
        
        activityIndicatorView.anchor
            .topToSuperview()
            .leading(greaterOrEqual: contentView.leadingAnchor)
            .trailing(greaterOrEqual: contentView.trailingAnchor)
            .centerXToSuperview()
            .activate()
        
        titleLabel.anchor
            .top(to: activityIndicatorView.bottomAnchor, constant: 5)
            .leading(greaterOrEqual: contentView.leadingAnchor)
            .trailing(greaterOrEqual: contentView.trailingAnchor)
            .bottomToSuperview()
            .centerXToSuperview()
            .activate()
        
        contentView.anchor
            .centerToSuperview()
            .width(lessThanOrEqualToConstant: 200)
            .activate()
    }
    
    // MARK: Functions
    func startAnimating() {
        if let superview = superview {
            superviewInstance = superview
            self.anchor.edgesToSuperview().activate()
        } else if let superview = superviewInstance {
            superview.addSubview(self)
            self.anchor.edgesToSuperview().activate()
        }
        self.alpha = 0
        activityIndicatorView.startAnimating()
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.alpha = 1
        }
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.alpha = 0
        }, completion: { [weak self] _ in
            self?.removeFromSuperview()
        })
    }
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var appleSignInButton: ASAuthorizationAppleIDButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var isLoading = false {
        didSet {
            activityIndicator.isHidden = !isLoading
            view.isUserInteractionEnabled = !isLoading
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        googleSignInButton.colorScheme = .dark
        appleSignInButton.cornerRadius = 5
        activityIndicator.isHidden = true
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
        if isLoading { return }
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
        isLoading = true
        PersistenceManagerFactory.userPersistenceManager.login(user: user) { [weak self] result in
            self?.isLoading = false
            print(result)
            switch result {
            case .success(let user):
                self?.dismiss(animated: true)
            case .failure(let error):
                let alert = UIAlertController(title: "Inicio de sesión fallido", message: "Hubo un error al iniciar sesión.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                alert.addAction(okAction)
                GIDSignIn.sharedInstance()?.signOut()
                self?.present(alert, animated: true)
            }
        }

        
    }
}
