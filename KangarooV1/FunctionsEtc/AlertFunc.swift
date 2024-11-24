//
//  AlertFunc.swift
//  KangarooV1
//
//  Created by Shaun on 20/11/20.
//


import Foundation
import UIKit
struct Alert
{
    private static func alertPopup(on vc:UIViewController,with title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    static func alertWithAction(on vc: UIViewController, with title:String, message:String, nav:UINavigationController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let submit = UIAlertAction(title: "Ok", style: .default){(action) in
            nav.popViewController(animated: true)
        }
        alert.addAction(submit)
        vc.present(alert, animated: true, completion: nil)
    }
    static func alertToGO(on vc: UIViewController, with title:String, message:String, tab:UITabBarController, index:Int, btnName:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let submit = UIAlertAction(title: "\(btnName)", style: .default){(action) in
            tab.selectedIndex = index
        }
        let cancel = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(submit)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    static func userLogin(on vc:UIViewController)
    {
        alertPopup(on: vc, with: "Error", message: "Invalid username or password.")
    }
    static func pwDiff(on vc:UIViewController, error:String)
    {
        alertPopup(on: vc, with: "Error", message: "\(error)")
    }
    static func numeric(on vc:UIViewController, error:String)
    {
        alertPopup(on: vc, with: "Error", message: "\(error) must be in numeric.")
    }
    static func emptyField(on vc:UIViewController)
    {
        alertPopup(on: vc, with: "Error", message: "Please fill in all textfield to proceed.")
    }
    static func passwordNoMatch(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Error", message: "Password does not match.")
    }
    static func notLogin(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Error", message: "Please login to add a product to cart.")
    }
    
    static func discountMsg(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Discount!", message: "Shake your device anytime during checkout to get a free discount!")
    }
    static func notEnough(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Error", message: "You do not have enough credit to purchase this item please top up credits under account details.")
    }
    static func emailError(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Error", message: "This is not in email format.")
    }
    static func userExists(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Error", message: "Username has been taken try again.")
    }
    static func addressError(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Error", message: "Address cannot be left empty.")
    }
    static func loginFail(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Error", message: "Login fail username/password does not exist.")
    }
    static func emailFail(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Error", message: "Sorry Email does not exist.")
    }
    static func emailTaken(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Error", message: "Email is already taken.")
    }
    static func creditPlus(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Done", message: "Top-up sucessful.")
    }
    
    static func wrongAnswer(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Error", message: "Answer do not match with ours.")
    }
    static func cannotShake(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "No abusing.", message: "You have already shaken you're not allowed to shake again.")
    }
    static func passwordShort(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Error", message: "Password is too short, try again.")
    }
    static func passwordNoNum(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Error", message: "Password does not contain a digit.")
    }
    static func wastedShake(on vc: UIViewController)
    {
        alertPopup(on: vc, with: "Oh no", message: "You have wasted your discount! Proceed to paayment to get a discount.")
    }
}
