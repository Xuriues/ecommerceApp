//
//  searchNavController.swift
//  KangarooV1
//
//  Created by Shaun on 2/12/20.
//

import UIKit

class searchNavController: UINavigationController {
    var productList = [ProductSports]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchVC = viewControllers[0] as! searchViewController
        searchVC.searchItemList = productList
        searchVC.filterData = productList
    }
}
