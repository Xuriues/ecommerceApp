//
//  forgotPasswordVC.swift
//  KangarooV1
//
//  Created by Shaun on 4/12/20.
//

import UIKit
import CoreData
class forgotPasswordVC: UIViewController {
    var user = User()
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var emailTxt: FloatingLabelInput!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.setBottomBorder()
        hideKeyboardOnTapAround()
        setup()
        
    }
    @IBAction func btnNext(_ sender: UIButton)
    {
        let validLogin = isValidEmail(testStr: emailTxt.text!)
        if validLogin
        {
           if getEmail(email: emailTxt.text!)
           {
                print(user.answer!)
                performSegue(withIdentifier: "view1", sender: self)
           }
           else
           {
                Alert.emailFail(on: self)
           }
        }
        else
        {
            Alert.emailError(on: self)
        }
    }
    
    
    @IBAction func backtoLogin(_ sender: UIBarButtonItem)
    {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginPage = main.instantiateViewController(identifier: "loginPage")
        self.present(loginPage , animated:true , completion: nil)
    }
    
    func getEmail(email:String)->Bool
    {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let fetchReq:NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
            fetchReq.predicate = NSPredicate(format: "email == %@", emailTxt.text!)
            let data = try? context.fetch(fetchReq)
            let array = data as! [User]
            if array.count > 0
            {
                for x in 0..<array.count
                {
                    user = array[x]
                    print(true)
                    return true
                }
            }
        }
        print(false)
        return false
    }
    
    func setup()
    {
        let myColor = UIColor.gray
        
        
        btnNext.setTitleColor(UIColor.darkGray, for: .normal)
        btnNext.layer.borderWidth = 1
        btnNext.backgroundColor = .clear
        btnNext.layer.borderColor = myColor.cgColor
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "view1"
        {
            let vc : questionViewcontroller = segue.destination as! questionViewcontroller
            vc.user = user
        }
    }
}
