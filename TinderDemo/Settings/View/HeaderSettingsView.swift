//
//  HeaderSettingsView.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 26.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class CustomPickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class HeaderLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}

class HeaderSettingsView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    var settingsController: SettingsController!
    
    @objc fileprivate func handleSelectPhoto(sender: UIButton) {
      
        let imagePicker = CustomPickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .overFullScreen
        imagePicker.imageButton = sender
        settingsController.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedPhoto = info[.editedImage] as? UIImage else {return}
        guard let imageButton = (picker as? CustomPickerController)?.imageButton else {return}
        
        imageButton.setImage(selectedPhoto.withRenderingMode(.alwaysOriginal), for: .normal)
        settingsController.dismiss(animated: true, completion: nil)
        
        guard let uploadImage = selectedPhoto.jpegData(compressionQuality: 0.75) else {return}
        let filename = UUID().uuidString
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: settingsController.view)
        let storageReference = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        storageReference.putData(uploadImage, metadata: nil) { (storageMetadata, error) in
            hud.dismiss()
            if let error = error {
                print("Failed to upload new image", error)
                return
            }
            print("Finished uploading image")
            storageReference.downloadURL { (url, error) in
                if let error = error {
                    print("Failed to retrieve download url", error)
                    return
                }
                print("Finished getting download url", url?.absoluteURL ?? "")
                
                guard let url = url?.absoluteString else {return}
                
                switch imageButton {
                case self.image1Button:
                    self.settingsController.user?.image1Url = url
                case self.image2Button:
                    self.settingsController.user?.image2Url = url
                case self.image3Button:
                    self.settingsController.user?.image3Url = url
                default:
                    ()
                }
            }
        }
    }
    
    fileprivate func setupLayout() {
        
        let padding: CGFloat = 16
        let rightStackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        rightStackView.axis = .vertical
        rightStackView.distribution = .fillEqually
        rightStackView.spacing = padding
        
        let overallStackView = UIStackView(arrangedSubviews: [image1Button, rightStackView])
        overallStackView.axis = .horizontal
        overallStackView.distribution = .fillEqually
        overallStackView.spacing = padding
        
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }
    
}
