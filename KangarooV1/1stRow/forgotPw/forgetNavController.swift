//
//  forgetNavController.swift
//  KangarooV1
//
//  Created by Shaun on 9/12/20.
//

import UIKit

class forgetNavController: UINavigationController, HalfModalPresentable{
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isHalfModalMaximized() ? .default : .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
