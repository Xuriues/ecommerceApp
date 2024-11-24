//
//  mainTabBarController.swift
//  KangarooV1
//
//  Created by Shaun on 2/12/20.
//

import UIKit

class mainTabBarController: UITabBarController {
    var productList = [ProductSports]()
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .tabBarColor
        let collectionNVC = self.viewControllers![2] as! collectionNavController
        let searchNVC = self.viewControllers![1] as! searchNavController
        collectionNVC.productList = productList
        searchNVC.productList = productList
    }
}
