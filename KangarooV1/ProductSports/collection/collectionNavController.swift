//
//  collectionNavController.swift
//  KangarooV1
//
//  Created by Shaun on 2/12/20.
//

import UIKit

class collectionNavController: UINavigationController {
    var productList = [ProductSports]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let sportVC = viewControllers[0] as! sportVC
        sportVC.OGItem = productList
        sportVC.itemList = productList
        
    }

}
