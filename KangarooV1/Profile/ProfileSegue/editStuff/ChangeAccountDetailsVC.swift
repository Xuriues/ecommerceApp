//
//  ChangeAccountDetailsVC.swift
//  KangarooV1
//
//  Created by Shaun on 20/11/20.
//

import UIKit
import CoreData
class ChangeAccountDetailsVC: UIViewController, UITabBarDelegate {
    @IBOutlet weak var mainView: UIView!
    var user = User()
    var checkUser = [User]()
    @IBOutlet weak var passwordTxt: FloatingLabelInput!
    @IBOutlet weak var usernameTxt: FloatingLabelInput!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var barItem: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        user = getUser()
        checkUser = getUserData()
        setup()
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1
        {
            
            passwordView.isHidden = true
            mainView.isHidden = false
        }
        else
        {
            
            mainView.isHidden = true
            passwordView.isHidden = false
        }
    }
    
    @IBAction func saveBtn(_ sender: UIButton)
    {
        if checkIndex1()
        {
            if checkexists()
            {
                user.username = usernameTxt.text
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                 Alert.alertWithAction(on: self, with: "Successfully Updated", message: "Changes has been made.", nav: navigationController!)
            }
            else
            {
                Alert.userExists(on: self)
            }
        }
    }
    @IBAction func btnAddCredits(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "Top-Up Credits", message: "Balance: \(user.credit)", preferredStyle: .alert)
        alert.addTextField()
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        cancel.setValue(UIColor.red, forKey: "titleTextColor")
        let saveBtn = UIAlertAction(title: "Top-Up", style: .default){ [self](action) in
            let textField = alert.textFields![0]
            if Double(textField.text!) != nil
            {
                user.credit += Double(textField.text!)!
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                Alert.alertWithAction(on: self, with: "Done", message: "Top-up sucessful.", nav: navigationController!)
            }
            else
            {
                Alert.numeric(on: self, error: "Only numbers.")
            }
        }
        alert.addAction(saveBtn)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkIndex1()->Bool
    {
        if usernameTxt.text != "" && passwordTxt.text != ""
        {
                if passwordTxt.text == user.password
                {
                    return true
                }
                else
                { Alert.passwordNoMatch(on: self)}
        }
        else
        {
            Alert.emptyField(on: self)
        }
        return false
    }
    
    func setup()
    {
        tabBar.delegate = self
        tabBar.selectedItem = barItem
        passwordView.isHidden = true
        passwordTxt.setBottomBorder()
        usernameTxt.setBottomBorder()
        self.hideKeyboardOnTapAround()
        passwordTxt.becomeFirstResponder()
        usernameTxt.becomeFirstResponder()
        passwordTxt.textContentType = .oneTimeCode
    }
    
    
    func checkexists()->Bool
    {
        var flag = true
        let username = usernameTxt.text
        for x in 0..<checkUser.count
        {
            if checkUser[x].username == username
            {
                flag = false
            }
        }
        return flag
    }
}
