//
//  LoginViewController.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 27.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

protocol LoginControllerDelegate {
    func didFinishLogginIn()
}

class LoginViewController: UIViewController {

    //MARK: - CONSTANTS && VARIABLES
    
    fileprivate let loginViewModel = LoginViewModel()
    fileprivate var delegate: LoginControllerDelegate?
    fileprivate var topConstraint: NSLayoutConstraint?
    fileprivate var buttonHeightConstraint: NSLayoutConstraint?
    
    //MARK: - INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNotifications()
        setupRegistrationViewModelObserver()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    //MARK: - UI ELEMENTS
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16, intrinsicSize: CGSize(width: 0, height: 50))
        tf.placeholder = "Enter email"
        tf.backgroundColor = .white
        tf.keyboardType = .emailAddress
        tf.layer.cornerRadius = 25
        tf.addTarget(self, action: #selector(handleTextInput), for: .editingChanged)
        return tf
    }()
    
    let passwordNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16, intrinsicSize: CGSize(width: 0, height: 50))
        tf.placeholder = "Enter password"
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        tf.layer.cornerRadius = 25
        tf.textContentType = .oneTimeCode
        tf.addTarget(self, action: #selector(handleTextInput), for: .editingChanged)
        return tf
    }()
    
    lazy var logInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .heavy)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var backToRegister: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back To Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleBackToRegister), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [emailTextField, passwordNameTextField, logInButton])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    fileprivate lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.colors = [#colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1), #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)].map{$0.cgColor}
        view.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    
    fileprivate let scrollView = UIScrollView()
    fileprivate let loginHUD = JGProgressHUD(style: .dark)
    
    //MARK: - USER INTERACTIONS
    
    @objc func handleBackToRegister() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @objc func handleTextInput() {
        guard let emailText = emailTextField.text,
            let passwordText = passwordNameTextField.text else {return}
        
        loginViewModel.email = emailText
        loginViewModel.password = passwordText
    }
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifications(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifications(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleNotifications(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardRect = keyboardFrame.cgRectValue
        let isKeyboardShowing = (notification.name == UIResponder.keyboardWillShowNotification)
        let adjustmentHeight = keyboardRect.height + 100
        scrollView.contentInset.bottom = isKeyboardShowing ? adjustmentHeight : 0
    }
    
    //MARK: - DEFAULT METHODS
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            topConstraint?.constant = 100
        } else {
            topConstraint?.constant = 300
        }
    }
    
    //MARK: - CUSTOM METHODS
    
    fileprivate func setupRegistrationViewModelObserver() {
        loginViewModel.bindableIsFormValid.bind { [unowned self] isFormValid in
            guard let isFormValid = isFormValid else {return}
            self.logInButton.isEnabled = isFormValid
            self.logInButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1) : .lightGray
        }
        
        loginViewModel.bindableIsSigningIn.bind { [unowned self] (isSigningIn) in
            if isSigningIn! {
                self.loginHUD.textLabel.text = "Log In"
                self.loginHUD.show(in: self.scrollView)
            } else {
                self.loginHUD.dismiss()
            }
        }
    }
    
    fileprivate func showHUDWithError(_ error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Log In"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.scrollView, animated: true)
        hud.dismiss(afterDelay: 4, animated: true)
    }
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(verticalStackView)
        scrollView.addSubview(backToRegister)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.anchor(top: nil, leading: verticalStackView.superview!.leadingAnchor, bottom: verticalStackView.superview!.bottomAnchor, trailing: verticalStackView.superview!.trailingAnchor)
        
        topConstraint = verticalStackView.topAnchor.constraint(equalTo: verticalStackView.superview!.topAnchor, constant: 0)
        if self.traitCollection.verticalSizeClass == .compact {
            topConstraint?.constant = 100
        } else {
            topConstraint?.constant = 300
        }
        topConstraint?.isActive = true
        verticalStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        
        backToRegister.anchor(top: nil, leading: scrollView.leadingAnchor, bottom: scrollView.safeAreaLayoutGuide.bottomAnchor, trailing: scrollView.trailingAnchor)
    }
    
    //MARK: - FIREBASE METHODS
    
    @objc func handleLogin() {
        handleTap()
        loginViewModel.performLogin { [weak self] (error) in
            self?.loginHUD.dismiss()
            if let error = error {
                self?.showHUDWithError(error)
                return
            }
            print("Logged in successfully")
            self?.dismiss(animated: true, completion: {
                let homeVC = HomeController()
                self?.navigationController?.pushViewController(homeVC, animated: true)
            })
        }
    }
}

