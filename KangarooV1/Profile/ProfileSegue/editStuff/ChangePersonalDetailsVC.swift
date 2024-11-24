//
//  ChangePersonalDetailsVC.swift
//  KangarooV1
//
//  Created by Shaun on 20/11/20.
//

import UIKit
import CoreData

class ChangePersonalDetailsVC: UIViewController {
    var userName = ""
    var userLastname = ""
    var userContact:Int32 = 0
    var userEmail:String = ""
    var user = User()
    @IBOutlet weak var nameTxt: FloatingLabelInput!
    @IBOutlet weak var lastnameTxt: FloatingLabelInput!
    @IBOutlet weak var contactTxt: FloatingLabelInput!
    @IBOutlet weak var emailTxt: FloatingLabelInput!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTxt._placeholder = "Name"
        setup()
        user = getUser()
    }
    

    @IBAction func saveBtn(_ sender: UIButton)
    {
        if check()
        {
            user.name = nameTxt.text
            user.lastName = lastnameTxt.text
            user.contact = Int32(contactTxt.text!)!
            user.email = emailTxt.text
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            Alert.alertWithAction(on: self, with: "Successfully Updated", message: "Personal details has been updated.", nav: navigationController!)
        }
    }
    

}
extension ChangePersonalDetailsVC
{
    func setup()
    {
        nameTxt.setBottomBorder()
        lastnameTxt.setBottomBorder()
        contactTxt.setBottomBorder()
        emailTxt.setBottomBorder()
        
        self.hideKeyboardOnTapAround()

        contactTxt.delegate = self
        nameTxt.becomeFirstResponder()
        lastnameTxt.becomeFirstResponder()
        contactTxt.becomeFirstResponder()
        emailTxt.becomeFirstResponder()
        
        nameTxt.text = userName
        lastnameTxt.text = userLastname
        contactTxt.text = String(userContact)
        emailTxt.text = userEmail
        
    }
    
    func check()->Bool
    {
        let validLogin = isValidEmail(testStr: emailTxt.text!)
        if nameTxt.text != "" && lastnameTxt.text != "" && contactTxt.text != "" && emailTxt.text != ""
        {
            if validLogin{
                if Int32(contactTxt.text!) != nil
                {
                    return true
                }
                else{Alert.numeric(on: self, error: "Must be numeirc number.")}
            }
            else{Alert.emailError(on: self)}
        }
        else
        {Alert.emptyField(on: self)}
        return false
    }
}
extension ChangePersonalDetailsVC: UITextFieldDelegate
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
