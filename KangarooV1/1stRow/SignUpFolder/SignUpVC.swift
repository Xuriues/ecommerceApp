//
//  SignUpVC.swift
//  KangarooV1
//
//  Created by Shaun on 20/11/20.
//

import UIKit
import CoreData

class SignUpVC: UIViewController {
    var checkUser:[User] = []
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var cpTxt: FloatingLabelInput!
    @IBOutlet weak var pTxt: FloatingLabelInput!
    @IBOutlet weak var userTxt: FloatingLabelInput!
    @IBOutlet weak var progressPassword: UIProgressView!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var progressCfmPass: UIProgressView!
    @IBOutlet weak var lblCfmPass: UILabel!
    @IBOutlet weak var heightPWCon: NSLayoutConstraint!
    @IBOutlet weak var heightCfmCon: NSLayoutConstraint!
    
    var pwValid: Bool = false
    var cpwValid:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUpKeyBoard()
        checkUser = getUserData()
        for x in 0..<checkUser.count
        {
            print(checkUser.count)
            print("\(checkUser[x].username!) \(checkUser[x].id) \(checkUser[x].password!)")
        }

    }
    @IBAction func btnDismiss(_ sender: UIBarButtonItem)
    {
        if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
            delegate.interactiveDismiss = false
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtn(_ sender: UIButton)
    {
        if checkInput()
        {
            if checkexists()
            {
                performSegue(withIdentifier: "pDetail", sender: self)
                print("Proceeded")
            }
            else
            {
                Alert.userExists(on: self)
            }
        }
    }
    
    @IBAction func passwordTxt(_ sender: UITextField)
    {
        if let password = pTxt.text, password.isNotEmpty {
            lblPassword.isHidden = false
            progressPassword.isHidden = false
            lblPassword.alpha = 0
            let validationId = StrengthManager.checkValidationWithUniqueCharacter(pass: password, rules: PasswordRules.passwordRule, minLength: PasswordRules.minPasswordLength, maxLength: PasswordRules.maxPasswordLength)
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                self?.lblPassword.alpha = CGFloat(validationId.alpha)
                self?.lblPassword.text  = validationId.text
            })
            
            let progressInfo = StrengthManager.setProgressView(strength: validationId.strength)
            pwValid = progressInfo.shouldValid
            progressPassword.setProgress(progressInfo.percentage, animated: true)
            progressPassword.progressTintColor = UIColor.colorFrom(hexString: progressInfo.color)
            
        } else {
            lblPassword.isHidden = false
            progressPassword.isHidden = false
            lblPassword.alpha = 0
            progressPassword.setProgress(0, animated: true)
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                self?.lblPassword.alpha = 1
                self?.lblPassword.text = "Password cannot be empty."
            }) { (_) in
                UIView.animate(withDuration: 0.8, delay: 0, options: [], animations: { [weak self] in
                    self?.lblPassword.alpha = 1
                    self?.lblPassword.isHidden = true
                    self?.progressPassword.isHidden = true
                })
            }
        }
    }
    
    
    
    @IBAction func cfmPass(_ sender: UITextField)
    {
        if let password = cpTxt.text, password.isNotEmpty
        {
            lblCfmPass.isHidden = false
            progressCfmPass.isHidden = false
            lblCfmPass.alpha = 0
            let validationId = StrengthManager.checkValidationWithUniqueCharacter(pass: password, rules:PasswordRules.passwordRule,minLength: PasswordRules.minPasswordLength, maxLength:PasswordRules.maxPasswordLength)
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                self?.lblCfmPass.alpha = CGFloat(validationId.alpha)
                self?.lblCfmPass.text  = validationId.text
            })
            
            let progressInfo = StrengthManager.setProgressView(strength: validationId.strength)
            cpwValid = progressInfo.shouldValid
            progressCfmPass.setProgress(progressInfo.percentage, animated: true)
            progressCfmPass.progressTintColor = UIColor.colorFrom(hexString: progressInfo.color)
            
        }
        else
        {
            lblCfmPass.isHidden = false
            lblCfmPass.alpha = 0
            progressCfmPass.setProgress(0, animated: true)
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                self?.lblCfmPass.alpha = 1
                self?.lblCfmPass.text = "Password cannot be empty."
            }) { (_) in
                UIView.animate(withDuration: 0.8, delay: 0, options: [], animations: { [weak self] in
                    self?.lblCfmPass.alpha = 1
                    self?.lblCfmPass.isHidden = true
                    self?.progressCfmPass.isHidden = true
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "pDetail")
        {
            let vc : pDetailVC = segue.destination as! pDetailVC
            vc.accountName = userTxt.text!
            vc.accountPassword = pTxt.text!
            vc.accountCfmPass = cpTxt.text!
        }
    }

}
extension SignUpVC
{
    func settingUpKeyBoard()
    {
        userTxt.setBottomBorder()
        cpTxt.setBottomBorder()
        pTxt.setBottomBorder()

      //addressTxt.setBottomBorder()
        self.hideKeyboardOnTapAround()
        userTxt.becomeFirstResponder()
        cpTxt.becomeFirstResponder()
        pTxt.becomeFirstResponder()
        
        let myColor = UIColor.gray
        
        btnNext.layer.borderWidth = 1
        btnNext.backgroundColor = .clear
        btnNext.setTitleColor(UIColor.darkGray, for: .normal)
        btnNext.layer.borderColor = myColor.cgColor
        
        
        userTxt.textContentType = .oneTimeCode
        cpTxt.textContentType = .oneTimeCode
        pTxt.textContentType = .oneTimeCode
        
        
        
        progressPassword.setProgress(0, animated: true)
        lblPassword.textColor = UIColor.red
        lblPassword.text = ""
        lblPassword.isHidden = true
        progressPassword.isHidden = true
        
        
        progressCfmPass.setProgress(0, animated: true)
        progressCfmPass.isHidden = true
        lblCfmPass.textColor = UIColor.red
        lblCfmPass.text = ""
        lblCfmPass.isHidden = true
    
    }
    
    func checkInput()->Bool
    {
        if userTxt.text != "" || pTxt.text != "" || cpTxt.text != ""
        {
                if pTxt.text == cpTxt.text
                {
                    let pString = pTxt.text
                    if pString!.count > 5
                    {
                        let decimalCharacters = CharacterSet.decimalDigits
                        let decimalRange = pString!.rangeOfCharacter(from: decimalCharacters)
                        if decimalRange != nil
                        {
                            return true
                        }
                        else
                        {
                            Alert.passwordNoNum(on: self)
                        }
                    }
                    else
                    {
                        Alert.passwordShort(on: self)
                    }
                }
                else
                {
                    Alert.passwordNoMatch(on: self)
                }
        }
        else
        {
            Alert.emptyField(on: self)
        }
        return false
    }
    
    func checkexists()->Bool
    {
        var flag = true
        let username = userTxt.text
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
