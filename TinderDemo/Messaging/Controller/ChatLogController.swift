//
//  ChatLogController.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 30.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: GenericViewController<MessageCell, Message>, MultilineInputAccessoryViewDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
    deinit {
        print("CHATLOGCONTROLLER ---- Object is destroying itself properly, no retain cycles")
    }


    //MARK: - CONSTANTS && VARIABLES
    fileprivate var listener: ListenerRegistration?
    fileprivate var match: Match
    fileprivate let navBarHeight: CGFloat = 120
    fileprivate var currentUser: User?
    
    //MARK: - INITIALIZATION
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.keyboardDismissMode = .interactive
        collectionView.alwaysBounceVertical = true
        
        fecthCurrentUser()
        setupLayout()
        fetchMessages()
        setupNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
           listener?.remove()
           containerView.delegate = nil
        }
    }
    
    //MARK: - UI ELEMENTS
    
    fileprivate lazy var customNavBar = MessagesNavBar(match: match)
    
    fileprivate let statusBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var containerView: AdaptiveMultilineAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let containerView = AdaptiveMultilineAccessoryView(frame: frame)
        containerView.delegate = self
        containerView.setupShadow(opacity: 0.4, radius: 8, offset: .init(width: 0, height: -10), color: UIColor(white: 0, alpha: 0.3))
        return containerView
    }()
    
    func chatStatus() {
//        print("printing")
    }
    
    override var inputAccessoryView: UIView? {
        return containerView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - USER INTERACTIONS
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - DEFAULT METHODS
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cell = MessageCell(frame: CGRect(x: 0, y: 0, width: width, height: 2000))
        cell.item = self.items[indexPath.item]
        cell.layoutIfNeeded()
        
        let estimatedSize = cell.systemLayoutSizeFitting(CGSize(width: width, height: 2000))
        return .init(width: width, height: estimatedSize.height)
    }
    
    //MARK: - CUSTOM METHODS
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func handleNotification(_ notification: Notification) {
        if self.items.count > 0 {
            self.collectionView.scrollToItem(at: [0, self.items.count - 1], at: .bottom, animated: true)
        }
    }
    
    fileprivate func setupLayout() {
        collectionView.backgroundColor = .white
        
        view.addSubview(customNavBar)
        view.addSubview(statusBarView)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))
        collectionView.contentInset.top = navBarHeight
        collectionView.verticalScrollIndicatorInsets.top = navBarHeight
        collectionView.contentInset.bottom = 10
        statusBarView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    //MARK: - FIREBASE METHODS
    
    fileprivate func fecthCurrentUser() {
        Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "").getDocument { (docSnapshot, error) in
            if let error = error {
                print("Failed to fetch current user", error)
                return
            }
            guard let dictionary = docSnapshot?.data() else {return}
            self.currentUser = User(userDictionary: dictionary)
        }
    }
    
    
    fileprivate func addMessage(message: String, fromId: String, toId: String) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        let messagesCollection =
            Firestore.firestore()
                .collection("matches_messages")
                .document(fromId)
                .collection(toId)
        
        
        let messageData: [String : Any] = [
            "text"      : message,
            "fromId"    : currentUID,
            "toId"      : match.uid,
            "timeStamp" : Timestamp(date: Date())
        ]
        
        messagesCollection.addDocument(data: messageData) { (error) in
            if let error = error {
                print("Failed to save the message", error)
                return
            }
            print("Successfully saved to db")
        }
    }

    fileprivate func saveToFromRecentMessages(message: String ) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        let recentMessagesCollection =
            Firestore.firestore()
                .collection("matches_messages")
                .document(currentUID)
                .collection("recentMessages")
                .document(match.uid)
        
        let messageData: [String : Any] = [
            "text"               : message,
            "name"               : match.name,
            "profileImageURL"    : match.profileImageURL,
            "timeStamp"          : Timestamp(date: Date()),
            "uid"                : match.uid,
            "fromId"             : currentUID
        ]
        
        recentMessagesCollection.setData(messageData) { (error) in
            if let error = error {
                print("Failed to save recent message", error)
                return
            }
            print("Successfully saved to db")
        }
        
        guard let currentUser = self.currentUser else {return}
        let toMessageData: [String : Any] = [
            "text"               : message,
            "name"               : currentUser.name ?? "",
            "profileImageURL"    : currentUser.image1Url ?? "",
            "timeStamp"          : Timestamp(date: Date()),
            "uid"                : currentUID,
            "fromId"             : currentUID
        ]
        
        Firestore.firestore()
            .collection("matches_messages")
            .document(match.uid)
            .collection("recentMessages")
            .document(currentUID).setData(toMessageData) { (error) in
                if let error = error {
                    print("Failed to save recent message", error)
                    return
                }
                print("Successfully saved to db")
            }
        
    }
    
    func didPost(for message: String) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        if !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            addMessage(message: message, fromId: currentUID, toId: match.uid)
            addMessage(message: message, fromId: match.uid, toId: currentUID)
            saveToFromRecentMessages(message: message)
        }
    }
    
    fileprivate func fetchMessages() {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        let query =
            Firestore.firestore()
                .collection("matches_messages")
                    .document(currentUID)
                        .collection(match.uid)
                            .order(by: "timeStamp")
        
        listener = query.addSnapshotListener { (messagesSnapshot, error) in
            if let error = error {
                print("Failed to fetch messages", error)
                return
            }
            messagesSnapshot?.documentChanges.forEach({ (documentChange) in
                if documentChange.type == .added {
                    let newMessage = documentChange.document.data()
                    self.items.append(Message(dictionary: newMessage))
                }
            })
            self.collectionView.reloadData()
            if self.items.count > 0 {
                self.collectionView.scrollToItem(at: [0, self.items.count - 1], at: .bottom, animated: false)
            }
        }
    }

    
}



