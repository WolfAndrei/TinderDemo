//
//  SettingsController.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 26.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsDelegate {
    func didSaveSettings()
}

class SettingsController: UITableViewController {
    
    deinit {
        print("Object is destroying itself properly, no retain cycles")
    }

    //MARK: - CONSTANTS && VARIABLES
    
    var delegate: SettingsDelegate?
    var user: User?
    static let defaultMinSeekingAge = 18
    static let defaultMaxSeekingAge = 50
    
    //MARK: - INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        fetchCurrentUser()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        header.settingsController = nil
    }
    
    //MARK: - UI ELEMENTS
    
    lazy var header: HeaderSettingsView = {
        let header = HeaderSettingsView()
        header.settingsController = self
        return header
    }()
    
    //MARK: - USER INTERACTIONS
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNameChange(_ textField: UITextField) {
        user?.name = textField.text
    }
    
    @objc func handleProfessionChange(_ textField: UITextField) {
        user?.profession = textField.text
    }
    
    @objc func handleAgeChange(_ textField: UITextField) {
        user?.age = Int(textField.text ?? "")
    }
    
    @objc func handleBioChange(_ textField: UITextField) {
    }
    
    @objc func handleMinAgeChange(slider: UISlider) {
         let indexPath = IndexPath(item: 0, section: 5)
         let cell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
         cell.minLabel.text = "Min \(Int(slider.value))"
         
         if slider.value >= cell.maxSlider.value {
             cell.maxSlider.value = slider.value
             cell.maxLabel.text = "Max \(Int(slider.value))"
             self.user?.maxSeekingAge = Int(cell.maxSlider.value)
         }
         self.user?.minSeekingAge = Int(slider.value)
     }
     
     @objc func handleMaxAgeChange(slider: UISlider) {
         let indexPath = IndexPath(item: 0, section: 5)
         let cell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
         cell.maxLabel.text = "Max \(Int(slider.value))"
         if slider.value <= cell.minSlider.value {
             slider.setValue(cell.minSlider.value, animated: false)
             cell.maxLabel.text = "Max \(Int(cell.minSlider.value))"
             self.user?.minSeekingAge = Int(cell.minSlider.value)
         }
         self.user?.maxSeekingAge = Int(slider.value)
     }
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifications(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifications(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleNotifications(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardValue.cgRectValue
        let adjustmentHeight = keyboardFrame.height + 100
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        tableView.contentInset.bottom = isKeyboardShowing ? adjustmentHeight : 0
    }
    
    //MARK: - DEFAULT METHODS
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        } else {
            let headerLabel = HeaderLabel()
            switch section {
            case 1:
                headerLabel.text = "Name"
            case 2:
                headerLabel.text = "Profession"
            case 3:
                headerLabel.text = "Age"
            case 4:
                headerLabel.text = "Bio"
            default:
                headerLabel.text = "Seeking Age Range"
            }
            headerLabel.font = .boldSystemFont(ofSize: 14)
            return headerLabel
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 300 : 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange(slider:)), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange(slider:)), for: .valueChanged)
            
            let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
            let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
            ageRangeCell.minLabel.text = "Min \(minAge)"
            ageRangeCell.minSlider.value = Float(minAge)
            ageRangeCell.maxLabel.text = "Max \(maxAge)"
            ageRangeCell.maxSlider.value = Float(maxAge)
            return ageRangeCell
        }
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange(_:)), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange(_:)), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.keyboardType = .decimalPad
            cell.textField.addTarget(self, action: #selector(handleAgeChange(_:)), for: .editingChanged)
            if let age = user?.age {
                cell.textField.text = String(age)
            }
        default:
            cell.textField.placeholder = "Enter Bio"
            cell.textField.addTarget(self, action: #selector(handleBioChange(_:)), for: .editingChanged)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - CUSTOM METHODS
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        let logOutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItems = [saveButton, logOutButton]
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .init(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
    }
    
    //MARK: - FIREBASE METHODS
    
    fileprivate func fetchCurrentUser() {
        Firestore.firestore().fetchCurrentUser { (user, error) in
            if let error = error {
                print("Failed to fetch user", error)
                return
            }
            self.user = user
            self.tableView.reloadData()
            self.loadPhoto(urls: [self.user?.image1Url, self.user?.image2Url, self.user?.image3Url],
                           buttons: [self.header.image1Button, self.header.image2Button, self.header.image3Button])
        }
    }
    
    fileprivate func loadPhoto(urls: [String?], buttons: [UIButton]) {
        urls.enumerated().forEach { (index, url) in
            guard let imageURL = url, let url = URL(string: imageURL) else {return}
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, data, error, cache, success, url) in
                buttons[index].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }

    @objc func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let dbReference = Firestore.firestore().collection("users").document(uid)
        
        let documentData : [String : Any] = [
            "uid": uid,
            "fullName" : user?.name ?? "",
            "image1Url" : user?.image1Url ?? "",
            "image2Url" : user?.image2Url as Any,
            "image3Url" : user?.image3Url as Any,
            "age" : user?.age ?? -1,
            "profession" : user?.profession ?? "",
            "minSeekingAge" : user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge,
            "maxSeekingAge" : user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
            ]
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)
        dbReference.setData(documentData) { (error) in
            hud.dismiss()
            if let error = error {
                print("Failed to save user settings", error)
                return
            }
            print("Finished saving user info")
            self.dismiss(animated: true) {
                self.delegate?.didSaveSettings()
            }
        }
    }
    
    @objc func handleLogOut() {
        let firabaseAuth = Auth.auth()
        do {
            try firabaseAuth.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
}
