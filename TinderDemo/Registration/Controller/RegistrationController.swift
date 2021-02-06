//
//  RegistrationController.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 23.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationController: UIViewController {

    //MARK: - CONSTANTS && VARIABLES
    
    let registrationViewModel = RegistrationViewModel()
    var buttonHeightConstraint: NSLayoutConstraint?
    var buttonWidthConstraint: NSLayoutConstraint?
    var delegate: LoginControllerDelegate?
    
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
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleImagePicker), for: .touchUpInside)
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16, intrinsicSize: CGSize(width: 0, height: 50))
        tf.backgroundColor = .white
        tf.placeholder = "Enter full name"
        tf.layer.cornerRadius = 25
        tf.addTarget(self, action: #selector(handleTextInput), for: .editingChanged)
        return tf
    }()
    
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
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .heavy)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go To Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordNameTextField, registerButton])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    lazy var overallStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selectPhotoButton, verticalStackView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.colors = [#colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1), #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)].map{$0.cgColor}
        view.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    
    let scrollView = UIScrollView()
    
    let registeringHUD = JGProgressHUD(style: .dark)
    
    //MARK: - USER INTERACTIONS
    
    @objc func handleGoToLogin() {
        let loginController = LoginViewController()
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    @objc func handleTextInput() {
          guard   let usernameText = fullNameTextField.text,
              let emailText = emailTextField.text,
              let passwordText = passwordNameTextField.text else {return}
          registrationViewModel.fullName = usernameText
          registrationViewModel.email = emailText
          registrationViewModel.password = passwordText
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
            buttonHeightConstraint?.isActive = false
            buttonWidthConstraint?.isActive = true
            overallStackView.axis = .horizontal
            overallStackView.distribution = .fillEqually
        } else {
            buttonWidthConstraint?.isActive = false
            buttonHeightConstraint?.isActive = true
            
            overallStackView.axis = .vertical
            overallStackView.distribution = .fill
        }
    }
    
    //MARK: - CUSTOM METHODS
    
    fileprivate func showHUDWithError(_ error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.scrollView, animated: true)
        hud.dismiss(afterDelay: 4, animated: true)
    }
    
    func setupRegistrationViewModelObserver() {
        registrationViewModel.bindableIsFormValid.bind { [unowned self] isFormValid in
            guard let isFormValid = isFormValid else {return}
            self.registerButton.isEnabled = isFormValid
            self.registerButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1) : .lightGray
        }
        
        registrationViewModel.bindableImage.bind { [unowned self] (image) in
            self.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationViewModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
            if isRegistering! {
                self.registeringHUD.textLabel.text = "Register"
                self.registeringHUD.show(in: self.scrollView)
            } else {
                self.registeringHUD.dismiss()
            }
        }
    }
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(overallStackView)
        scrollView.addSubview(goToLoginButton)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.fillSuperview(padding: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0))
        overallStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        buttonWidthConstraint = selectPhotoButton.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.6)

        buttonHeightConstraint = selectPhotoButton.heightAnchor.constraint(equalTo: overallStackView.widthAnchor)
        buttonWidthConstraint?.isActive = false
        buttonHeightConstraint?.isActive = true
        
        goToLoginButton.anchor(top: nil, leading: scrollView.leadingAnchor, bottom: scrollView.safeAreaLayoutGuide.bottomAnchor, trailing: scrollView.trailingAnchor)
    }
    
    //MARK: - FIREBASE METHODS
    
    @objc func handleRegister() {
        handleTap()
        registrationViewModel.performRegistration { [weak self] (error) in
            self?.registeringHUD.dismiss()
            if let error = error {
                self?.showHUDWithError(error)
                return
            }
            print("Finished registering new user")
            
            self?.dismiss(animated: true) {
                let homeVC = HomeController()
                self?.navigationController?.pushViewController(homeVC, animated: true)
            }
        }
    }
}

//MARK: - EXTENSIONS

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedPhoto = info[.editedImage] as? UIImage {
            registrationViewModel.bindableImage.value = selectedPhoto
            registrationViewModel.checkFormValidity()
            selectPhotoButton.setTitle(nil, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}
