//
//  MatchesMessagesController.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 29.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase


//MARK: - CONSTANTS && VARIABLES
//MARK: - INITIALIZATION
//MARK: - UI ELEMENTS
//MARK: - USER INTERACTIONS
//MARK: - DEFAULT METHODS
//MARK: - CUSTOM METHODS
//MARK: - EXTENSIONS
struct RecentMessage {
    let text, uid, name, profileImageURL, fromId: String
    let timestamp: Timestamp
    let isMyMessage: Bool
    
      init(dictionary: [String: Any]) {
         self.text = dictionary["text"] as? String ?? ""
         self.name = dictionary["name"] as? String ?? ""
         self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
         self.uid = dictionary["uid"] as? String ?? ""
         self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
         self.fromId = dictionary["fromId"] as? String ?? ""
         self.isMyMessage = Auth.auth().currentUser!.uid == self.fromId
     }
}

class RecentMessageCell: GenericCell <RecentMessage> {
    
    
    override var item: RecentMessage! {
        didSet {
            usernameLabel.text = "\(item.name)"
            recentMessageLabel.text = item.text
            imageView.sd_setImage(with: URL(string: item.profileImageURL), completed: nil)
            isMyMessage.isHidden = !item.isMyMessage
        }
    }
    
    //MARK: - UI ELEMENTS
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "jane3")
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let isMyMessage: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemBlue
        label.text = "You"
        return label
    }()
    
    
    let sepatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    let recentMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        label.text = "Text here"
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .black
        label.text = "Username here"
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    //MARK: - DEFAULT METHODS
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.height / 2
    }
    
    //MARK: - CUSTOM METHODS
    
    override func setupLayout() {
        super.setupLayout()
        
        addSubview(imageView)
        addSubview(sepatorView)
        
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 20, left: 20, bottom: 20, right: 0))
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1).isActive = true
        sepatorView.anchor(top: nil, leading: imageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
        setupStackView()
    }
    
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, isMyMessage, recentMessageLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        addSubview(stackView)
        
        stackView.anchor(top: topAnchor, leading: imageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 15, left: 20, bottom: 15, right: 20))
    }
    
    
}







class MatchesMessagesController: GenericHeaderViewController<RecentMessageCell, RecentMessage, MatchesHeader>, UICollectionViewDelegateFlowLayout {
    
    
     fileprivate var listener: ListenerRegistration?
    
    //MARK: - INITIALIZATION
   
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         if isMovingFromParent {
            listener?.remove()
         }
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewSetup()
        setupLayout()
        fetchRecentMessages()
        navBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    deinit {
        print("MATCHESMESSAGESCONTROLLER ---- Object is destroying itself properly, no retain cycles")
    }
    
    //MARK: - UI ELEMENTS
    
    let navBar = MatchesNavBar()
    
    let statusBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    //MARK: - USER INTERACTIONS
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - DEFAULT METHODS
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        return .init(width: width, height: 130)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recentMessage = items[indexPath.item]
        let dictionary = ["name" : recentMessage.name, "profileImageURL" : recentMessage.profileImageURL, "uid" : recentMessage.uid]
        let match = Match(dictionary: dictionary)
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: - CUSTOM METHODS
    
    override func setupHeader(_ header: MatchesHeader) {
        header.horizontalViewController.rootMatchesController = self
    }
    
    func didSelectMatchesFromRoot(match: Match) {
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    fileprivate func collectionViewSetup() {
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 3
        }
    }
    
    func setupLayout() {
        collectionView.contentInset.top = 130
        
        view.addSubview(navBar)
        view.addSubview(statusBarView)
        
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 130))
        statusBarView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    //MARK: - FIREBASE METHODS
    
    var recentMessagesDictionary = [String: RecentMessage]()
    
    fileprivate func fetchRecentMessages() {
        guard let currentUId = Auth.auth().currentUser?.uid else {return}
        
        let query = Firestore.firestore().collection("matches_messages").document(currentUId).collection("recentMessages")
        
        listener = query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Failed to fetch recent message", error)
                return
            }
            
            querySnapshot?.documentChanges.forEach({ (change) in
                if change.type == .added || change.type == .modified {
                    let dictionary = change.document.data()
                    
                    let recentMessage = RecentMessage(dictionary: dictionary)
                    self.recentMessagesDictionary[recentMessage.uid] = recentMessage
                }
            })
            self.resetItems()
        }
    }

    fileprivate func resetItems() {
        let values = Array(recentMessagesDictionary.values)
        items = values.sorted(by: { (rm1, rm2) -> Bool in
            return rm1.timestamp.compare(rm2.timestamp) == .orderedDescending
        })
        collectionView.reloadData()
    }
    
}
