//
//  NotLoginVC.swift
//  KangarooV1
//
//  Created by Shaun on 20/11/20.
//

import UIKit

class NotLoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginViewBtn(_ sender: UIButton)
    {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginPage = main.instantiateViewController(identifier: "loginPage")
        self.present(loginPage , animated:true , completion: nil)
    }
    
    @IBAction func signupViewBtn(_ sender: UIButton)
    {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let signUp = main.instantiateViewController(identifier: "signup")
        self.present(signUp , animated:true , completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
