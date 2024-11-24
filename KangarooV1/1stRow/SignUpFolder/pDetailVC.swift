//
//  pDetailVC.swift
//  KangarooV1
//
//  Created by Shaun on 23/11/20.
//

import UIKit

class pDetailVC: UIViewController {
    var accountName:String = ""
    var accountPassword:String = ""
    var accountCfmPass:String = ""
    var checkUser:[User] = []
    var qPicker = UIPickerView()
    let toolBar = UIToolbar()
    var arrayQuestion:[String] = ["What is god?", "Name of your first pet?", "Name of your first crush?", "What is death?"]
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var nameText: FloatingLabelInput!
    @IBOutlet weak var lastnameText: FloatingLabelInput!
    @IBOutlet weak var contactText: FloatingLabelInput!
    @IBOutlet weak var emailText: FloatingLabelInput!
    @IBOutlet weak var questionTxt: FloatingLabelInput!
    @IBOutlet weak var answerTxt: FloatingLabelInput!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUser = getUserData()
        print(accountName)
        print(accountPassword)
        print(accountCfmPass)
        settingUpKeyBoard()
    }
    

    @IBAction func btnSubmit(_ sender: UIButton)
    {
        if accountName != "" && accountPassword != "" && accountCfmPass != ""
        {
            if check()
            {
                setData(user: accountName, pass: accountPassword, name:  nameText.text!, lastName: lastnameText.text!, contact: Int32(contactText.text!)!, email: emailText.text!,ques: questionTxt.text! ,ans: answerTxt.text! ,entity: checkUser )
                let alert = UIAlertController(title: "Registered", message: "Successfully registerd go back to login?", preferredStyle: .alert)
                let toLogin = UIAlertAction(title: "Login", style: .default){(action)
                    in
                    let main = UIStoryboard(name: "Main", bundle: nil)
                    let loginPage = main.instantiateViewController(identifier: "loginPage")
                    self.present(loginPage , animated:true , completion: nil)
                }
                let tomainPage = UIAlertAction(title: "Main Page", style: .default){(action) in
                    let main = UIStoryboard(name: "Main", bundle: nil)
                    let mainPage = main.instantiateViewController(identifier: "mainPage")
                    self.present(mainPage , animated:true , completion: nil)
                }
                alert.addAction(toLogin)
                alert.addAction(tomainPage)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
extension pDetailVC: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayQuestion.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(arrayQuestion[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        questionTxt.text = arrayQuestion[row]
    }
    func settingUpKeyBoard()
    {
        nameText.setBottomBorder()
        lastnameText.setBottomBorder()
        contactText.setBottomBorder()
        emailText.setBottomBorder()
        questionTxt.setBottomBorder()
        answerTxt.setBottomBorder()
        
        contactText.delegate = self
        
        
        qPicker.delegate = self
        questionTxt.inputView = qPicker
        toolBar.sizeToFit()
        let donebutton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(hideKeyboard))
        toolBar.setItems([donebutton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.tintColor = .black
        toolBar.barTintColor = .gray
        questionTxt.inputAccessoryView = toolBar
         
        self.hideKeyboardOnTapAround()
        nameText.becomeFirstResponder()
        lastnameText.becomeFirstResponder()
        contactText.becomeFirstResponder()
        emailText.becomeFirstResponder()
    
        
        let myColor = UIColor.gray
        
        btnSignUp.layer.borderWidth = 1
        btnSignUp.backgroundColor = .clear
        btnSignUp.layer.borderColor = myColor.cgColor
        btnSignUp.setTitleColor(UIColor.darkGray, for: .normal)
        
        nameText.textContentType = .oneTimeCode
        lastnameText.textContentType = .oneTimeCode
        contactText.textContentType = .oneTimeCode
        emailText.textContentType = .oneTimeCode
    }
    func checkexistsEmail()->Bool
    {
        var flag = true
        for x in 0..<checkUser.count
        {
            if checkUser[x].email == emailText.text
            {
                flag = false
            }
        }
        return flag
    }
    
    func check()->Bool
    {
        let validLogin = isValidEmail(testStr: emailText.text!)
        if nameText.text != "" && lastnameText.text != "" && contactText.text != "" && emailText.text != "" && questionTxt.text != "" && answerTxt.text != ""
        {
            if validLogin{
                if Int32(contactText.text!) != nil
                {
                    if checkexistsEmail()
                    {
                        return true
                    }
                    else
                    {
                        Alert.emailTaken(on: self)
                    }
                }
                else
                {
                    Alert.numeric(on: self, error: "Phone needs to be in numeric.")
                }
            }
            else
            {
                Alert.emailError(on: self)
            }
        }
        else
        {Alert.emptyField(on: self)}
        return false
    }
}
extension pDetailVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 16 characters
        return updatedText.count <= 8
    }
}
