//
//  UpdatePasswordViewController.swift
//  KangarooV1
//
//  Created by Shaun on 5/12/20.
//

import UIKit
import CoreData
class UpdatePasswordViewController: UIViewController {
    var user = User()
    @IBOutlet weak var passwordTxt: FloatingLabelInput!
    @IBOutlet weak var pwProg: UIProgressView!
    @IBOutlet weak var cfmProg: UIProgressView!
    @IBOutlet weak var pwLbl: UILabel!
    @IBOutlet weak var cfmLbl: UILabel!
    @IBOutlet weak var confirmPassTxt: FloatingLabelInput!
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTxt.setBottomBorder()
        confirmPassTxt.setBottomBorder()
        hideKeyboardOnTapAround()
        
        passwordTxt.textContentType = .oneTimeCode
        confirmPassTxt.textContentType = .oneTimeCode
        
        
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
    
    
    var pwValid = false
    var cfmValid = false
    
    @IBAction func updateBtn(_ sender: UIButton)
    {
        if passwordTxt.text == confirmPassTxt.text
        {
            let pString = passwordTxt.text
            if pString!.count > 5
            {
                let decimalCharacters = CharacterSet.decimalDigits
                let decimalRange = pString!.rangeOfCharacter(from: decimalCharacters)
                if decimalRange != nil
                {
                    user.password = passwordTxt.text
                    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                    print("save password")
                    let alert = UIAlertController(title: "Completed", message: "Password has been updated.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default){(action) in
                        let main = UIStoryboard(name: "Main", bundle: nil)
                        let loginPage = main.instantiateViewController(identifier: "loginPage")
                        self.present(loginPage , animated:true , completion: nil)
                    })
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    Alert.passwordNoNum(on: self)
                }
            }
        }
        else
        {
            Alert.pwDiff(on: self, error: "Password do no match.")
        }
    }
    
    
    @IBAction func pwChange(_ sender: UITextField)
    {
        if let password = passwordTxt.text, password.isNotEmpty {
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
    
    
    
    
    
    
}
