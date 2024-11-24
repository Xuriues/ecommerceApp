//
//  cartNotLogin.swift
//  KangarooV1
//
//  Created by Shaun on 27/11/20.
//

import UIKit

class cartNotLogin: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signup(_ sender: UIButton)// Login *
    {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginPage = main.instantiateViewController(identifier: "loginPage")
        self.present(loginPage , animated:true , completion: nil)
    }
    @IBAction func loginBtn(_ sender: Any) // Signup *
    {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let signUp = main.instantiateViewController(identifier: "signup")
        self.present(signUp , animated:true , completion: nil)
    }
    
}
