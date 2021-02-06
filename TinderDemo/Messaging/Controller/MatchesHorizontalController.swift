//
//  MatchesHorizontalViewController.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 03.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import Firebase


class MatchesHorizontalController: GenericViewController<CircleCell, Match> , UICollectionViewDelegateFlowLayout {
    
    weak var rootMatchesController: MatchesMessagesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 3
        }
        collectionView.showsHorizontalScrollIndicator = false
        fetchMatches()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = items[indexPath.item]
        rootMatchesController?.didSelectMatchesFromRoot(match: match)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 4, bottom: 0, right: 4)
    }
    
    fileprivate func fetchMatches() {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("matches_messages").document(currentUID).collection("matches").getDocuments { (snapshot, error) in
            if let error = error {
                print("Failed to fetch matches info", error)
                return
            }
            snapshot?.documents.forEach({ (docSnapshot) in
                let userData = docSnapshot.data()
                self.items.append(Match(dictionary: userData))
            })
            self.collectionView.reloadData()
        }
    }
    
}
