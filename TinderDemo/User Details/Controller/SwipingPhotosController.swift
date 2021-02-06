//
//  SwipingPhotosController.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 27.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import SDWebImage

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    //MARK: - CONSTANTS && VARIABLES
    
    var controllers = [UIViewController]()
    var isCardViewMode: Bool!
    
    var cardViewModel: CardViewModel? {
        didSet {
            if let cardViewModel = cardViewModel {
                controllers = cardViewModel.imageURLs.map({ (imageURL) -> UIViewController in
                    let photoController = PhotoController(imageURL: imageURL)
                    return photoController
                })
                setViewControllers([controllers.first!], direction: .forward, animated: true, completion: nil)
                setupBarStackView()
            }
        }
    }
    
    //MARK: - INITIALIZATION
    
    init(isCardViewMode: Bool) {
        self.isCardViewMode = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        if isCardViewMode {
            disableSwipingAbility()
        }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
    
    //MARK: - UI ELEMENTS
    
    fileprivate let grayColor = UIColor(white: 0, alpha: 0.1)
    fileprivate let barStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()
    
    //MARK: - USER INTERACTIONS
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let currentController = viewControllers!.first!
        if let index = self.controllers.firstIndex(of: currentController) {
            
            if gestureRecognizer.location(in: self.view).x > view.frame.width / 2 {
                let nextIndex = min(index + 1, controllers.count - 1)
                let nextVC = controllers[nextIndex]
                setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
                barStackView.arrangedSubviews.forEach{ $0.backgroundColor = grayColor }
                barStackView.arrangedSubviews[nextIndex].backgroundColor = .white
            } else {
                let prevIndex = max(0, index - 1)
                let prevVC = controllers[prevIndex]
                setViewControllers([prevVC], direction: .reverse, animated: true, completion: nil)
                barStackView.arrangedSubviews.forEach{ $0.backgroundColor = grayColor }
                barStackView.arrangedSubviews[prevIndex].backgroundColor = .white
            }
        }
    }
    
    //MARK: - DEFAULT METHODS
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}) {
            barStackView.arrangedSubviews.forEach{ $0.backgroundColor = grayColor }
            barStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 {return nil}
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 {return nil}
        return controllers[index + 1]
    }
    
    //MARK: - CUSTOM METHODS
    
    fileprivate func setupBarStackView() {
        cardViewModel?.imageURLs.forEach({ (_) in
            let barView = UIView()
            barView.backgroundColor = grayColor
            barView.layer.cornerRadius = 2
            barStackView.addArrangedSubview(barView)
        })
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        view.addSubview(barStackView)
        barStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
   
    fileprivate func disableSwipingAbility() {
        view.subviews.forEach { (view) in
            if let view = view as? UIScrollView{
                view.isScrollEnabled = false
            }
        }
    }
}


