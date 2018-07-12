//
//  MainVC.swift
//  DouYin
//
//  Created by Niu Changming on 19/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import Parchment


class CustomPagingView: PagingView {
    
    override func setupConstraints() {
        constrainToEdges(pageView)
    }
}

class CustomPagingViewController: FixedPagingViewController {
    override func loadView() {
        view = CustomPagingView(
            options: options,
            collectionView: collectionView,
            pageView: pageViewController.view)
    }
}

class MainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(hexString: Constants.ColorScheme.orangeColor)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let recommandVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "WorkVC")
        recommandVC.title = "视频"
        
        let featuredVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "LiveListVC")
        featuredVC.title = "直播"
        
        let momentVC: UIViewController = MomentVC()
        momentVC.title = "图文"
    
        let pagingViewController = CustomPagingViewController(viewControllers: [recommandVC, featuredVC, momentVC])
        pagingViewController.delegate = self
        pagingViewController.borderOptions = .hidden
        pagingViewController.menuBackgroundColor = .clear
        pagingViewController.indicatorColor = UIColor(hexString: Constants.ColorScheme.blackColor)
        pagingViewController.textColor = UIColor(hexString: Constants.ColorScheme.blackColor).withAlphaComponent(0.5)
        pagingViewController.selectedTextColor = UIColor(hexString: Constants.ColorScheme.blackColor)
        pagingViewController.selectedFont = UIFont.boldSystemFont(ofSize: 18.0)
        pagingViewController.font = UIFont.boldSystemFont(ofSize: 16.0)
        pagingViewController.menuItemSize = PagingMenuItemSize.sizeToFit(minWidth: 60, height: 40)

        addChildViewController(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParentViewController: self)
    
        navigationItem.titleView = pagingViewController.collectionView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "开播", style: .plain, target: self, action: #selector(broadcastTapped))
        
        if AuthUtils.shareManager.validate() == AuthType.UNAUTH {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: .plain, target: self, action: #selector(loginTapped))
        }else if AuthUtils.shareManager.validate() == AuthType.EXPIRED{
            loginTapped()
        }
        
        addCenterButton(withImage: UIImage(named: "camera")!, highlightImage: UIImage(named: "camera_sel")!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationItem.titleView?.frame = CGRect(origin: .zero, size: navigationBar.bounds.size)
    }
    
    @objc func broadcastTapped(){
        let broadcastVC = BroadcastVC()
        self.present(broadcastVC, animated: true, completion: nil)
    }
    
    @objc func loginTapped(){
        let loginVC = LoginVC()
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func addCenterButton(withImage buttonImage : UIImage, highlightImage: UIImage) {
        let paddingBottom : CGFloat = 33
        let button = UIButton(type: .custom)
        button.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        button.frame = CGRect(x: 0.0, y: 0.0, width: 50, height: 32)
        button.setImage(buttonImage, for: .normal)
        button.setImage(highlightImage, for: .highlighted)
        button.subviews.first?.contentMode = .scaleAspectFit
        
        let rectBoundTabbar = self.tabBarController?.tabBar.bounds
        let xx = rectBoundTabbar?.midX
        let yy = (rectBoundTabbar?.midY)! - paddingBottom/2
        button.center = CGPoint(x: xx!, y: yy)

        self.tabBarController?.tabBar.addSubview(button)
        self.tabBarController?.tabBar.bringSubview(toFront: button)
        
        if let count = self.tabBarController?.tabBar.items?.count{
            let i = floor(Double(count / 2))
            let item = self.tabBarController?.tabBar.items![Int(i)]
            item?.title = ""
        }
        
        let gradientLayer : CAGradientLayer = Utils.makeGradientColor(for: button)
        gradientLayer.cornerRadius = 8
        button.layer.insertSublayer(gradientLayer, below: button.imageView?.layer)
    }
    
}

extension MainVC: PagingViewControllerDelegate {
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, widthForPagingItem pagingItem: T, isSelected: Bool) -> CGFloat? {
        guard let item = pagingItem as? PagingIndexItem else { return 0 }
        
        let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: pagingViewController.menuItemSize.height)
        let attributes = [NSAttributedStringKey.font: pagingViewController.font]
        
        let rect = item.title.boundingRect(with: size,
                                           options: .usesLineFragmentOrigin,
                                           attributes: attributes,
                                           context: nil)
        
        let width = ceil(rect.width) + insets.left + insets.right
        
        if isSelected {
            return width * 1.5
        } else {
            return width
        }
    }
    
}
















