//
//  PasswordVC.swift
//  KangarooV1
//
//  Created by Shaun on 20/11/20.
//

import UIKit
import CoreData

class PasswordVC: UIViewController {
    var user = User()
    @IBOutlet weak var oldpassTxt: FloatingLabelInput!
    @IBOutlet weak var confirmPassTxt: FloatingLabelInput!
    @IBOutlet weak var newpassTxt: FloatingLabelInput!
    @IBOutlet weak var pwProg: UIProgressView!
    @IBOutlet weak var cfmProg: UIProgressView!
    @IBOutlet weak var pwLbl: UILabel!
    @IBOutlet weak var cfmLbl: UILabel!
    
    
    var flag1 = true
    var flag2 = true
    var flag3 = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
        user = getUser()
        print(id!)
        print(user.id)
        print(user.password!)
    }
    
    @IBAction func btnSave(_ sender: UIButton)
    {
       if checkIndex2()
        {
            user.password = newpassTxt.text
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
         Alert.alertWithAction(on: self, with: "Successfully Updated", message: "Changes has been made.", nav: navigationController!)
         
       }
    }
    

    var pwValid = false
    var cfmValid = false
    @IBAction func pwChange(_ sender: UITextField)
    {
        
            if let password = newpassTxt.text, password.isNotEmpty {
                pwLbl.isHidden = false
                pwProg.isHidden = false
                pwLbl.alpha = 0
                let validationId = StrengthManager.checkValidationWithUniqueCharacter(pass: password, rules: PasswordRules.passwordRule, minLength: PasswordRules.minPasswordLength, maxLength: PasswordRules.maxPasswordLength)
                UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                    self?.pwLbl.alpha = CGFloat(validationId.alpha)
                    self?.pwLbl.text  = validationId.text
                })
                
                let progressInfo = StrengthManager.setProgressView(strength: validationId.strength)
                pwValid = progressInfo.shouldValid
                pwProg.setProgress(progressInfo.percentage, animated: true)
                pwProg.progressTintColor = UIColor.colorFrom(hexString: progressInfo.color)
                
            } else {
                pwLbl.isHidden = false
                pwProg.isHidden = false
                pwLbl.alpha = 0
                pwProg.setProgress(0, animated: true)
                UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                    self?.pwLbl.alpha = 1
                    self?.pwLbl.text = "Password cannot be empty."
                }) { (_) in
                    UIView.animate(withDuration: 0.8, delay: 0, options: [], animations: { [weak self] in
                        self?.pwLbl.alpha = 1
                        self?.pwLbl.isHidden = true
                        self?.pwProg.isHidden = true
                    })
                }
            }
    }
    
    
    @IBAction func cfmChange(_ sender: UITextField)
    {
        if let password = confirmPassTxt.text, password.isNotEmpty {
            cfmLbl.isHidden = false
            cfmProg.isHidden = false
            cfmLbl.alpha = 0
            let validationId = StrengthManager.checkValidationWithUniqueCharacter(pass: password, rules: PasswordRules.passwordRule, minLength: PasswordRules.minPasswordLength, maxLength: PasswordRules.maxPasswordLength)
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                self?.cfmLbl.alpha = CGFloat(validationId.alpha)
                self?.cfmLbl.text  = validationId.text
            })
            
            let progressInfo = StrengthManager.setProgressView(strength: validationId.strength)
            cfmValid = progressInfo.shouldValid
            cfmProg.setProgress(progressInfo.percentage, animated: true)
            cfmProg.progressTintColor = UIColor.colorFrom(hexString: progressInfo.color)
            
        } else {
            cfmLbl.isHidden = false
            cfmProg.isHidden = false
            cfmLbl.alpha = 0
            cfmProg.setProgress(0, animated: true)
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                self?.cfmLbl.alpha = 1
                self?.cfmLbl.text = "Password cannot be empty."
            }) { (_) in
                UIView.animate(withDuration: 0.8, delay: 0, options: [], animations: { [weak self] in
                    self?.cfmLbl.alpha = 1
                    self?.cfmLbl.isHidden = true
                    self?.cfmProg.isHidden = true
                })
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any)
    {
        if flag1{
            button.setImage(UIImage(named: "32eye.png"), for: .normal)
        }
        else
        {
            button.setImage(UIImage(named: "cancelEyeIcon.png"), for: .normal)
        }
        flag1 = !flag1
        newpassTxt.isSecureTextEntry = !newpassTxt.isSecureTextEntry
    }
    @IBAction func refresh2(_ sender: Any)
    {
        if flag2{
            button2.setImage(UIImage(named: "32eye.png"), for: .normal)
        }
        else
        {
            button2.setImage(UIImage(named: "cancelEyeIcon.png"), for: .normal)
        }
        flag2 = !flag2
        confirmPassTxt.isSecureTextEntry = !confirmPassTxt.isSecureTextEntry
    }
    @IBAction func refresh3(_ sender: Any)
    {
        if flag3{
            button3.setImage(UIImage(named: "32eye.png"), for: .normal)
        }
        else
        {
            button3.setImage(UIImage(named: "cancelEyeIcon.png"), for: .normal)
        }
        flag3 = !flag3
        oldpassTxt.isSecureTextEntry = !oldpassTxt.isSecureTextEntry
    }
    func checkIndex2()->Bool
    {
        if newpassTxt.text != "" && confirmPassTxt.text != "" && oldpassTxt.text != ""
        {
            let pString = newpassTxt.text
            if pString!.count > 5
            {
                let decimalCharacters = CharacterSet.decimalDigits
                let decimalRange = pString!.rangeOfCharacter(from: decimalCharacters)
                if decimalRange != nil
                {
                    if newpassTxt.text == confirmPassTxt.text
                    {
                        if oldpassTxt.text == user.password
                        {
                            return true
                        }
                        else
                        {
                            Alert.pwDiff(on: self, error: "Passwords do not much")
                        }
                    }
                    else
                    {
                        Alert.pwDiff(on: self, error: "Passwords do not much")
                    }
                }
                else{Alert.passwordNoNum(on: self)}
            }
            else
            {Alert.passwordShort(on: self)}
        }
        else
        {
            Alert.emptyField(on: self)
        }
        return false
    }

    var button = UIButton(type: .custom)
    var button2 = UIButton(type: .custom)
    var button3 = UIButton(type: .custom)
    func setup()
    {
        button.setImage(UIImage(named: "cancelEyeIcon.png"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(newpassTxt.frame.size.width - 25), y: CGFloat(10), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)

        
        button2.setImage(UIImage(named: "cancelEyeIcon.png"), for: .normal)
        button2.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button2.frame = CGRect(x: CGFloat(confirmPassTxt.frame.size.width - 25), y: CGFloat(10), width: CGFloat(25), height: CGFloat(25))
        button2.addTarget(self, action: #selector(self.refresh2), for: .touchUpInside)
        
        
        button3.setImage(UIImage(named: "cancelEyeIcon.png"), for: .normal)
        button3.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button3.frame = CGRect(x: CGFloat(oldpassTxt.frame.size.width - 25), y: CGFloat(10), width: CGFloat(25), height: CGFloat(25))
        button3.addTarget(self, action: #selector(self.refresh3), for: .touchUpInside)
        
        
        
        
        newpassTxt.setBottomBorder()
        confirmPassTxt.setBottomBorder()
        oldpassTxt.setBottomBorder()
        
        newpassTxt.becomeFirstResponder()
        confirmPassTxt.becomeFirstResponder()
        oldpassTxt.becomeFirstResponder()
        
        
        
        newpassTxt.rightViewMode = .always
        confirmPassTxt.rightViewMode = .always
        oldpassTxt.rightViewMode = .always

        newpassTxt.rightView = button
        confirmPassTxt.rightView = button2
        oldpassTxt.rightView = button3
        
        self.hideKeyboardOnTapAround()
        
        pwProg.setProgress(0, animated: true)
        pwLbl.textColor = UIColor.red
        pwLbl.text = ""
        pwLbl.isHidden = true
        pwProg.isHidden = true
        
        
        cfmProg.setProgress(0, animated: true)
        cfmProg.isHidden = true
        cfmLbl.textColor = UIColor.red
        cfmLbl.text = ""
        cfmLbl.isHidden = true
    }
}
