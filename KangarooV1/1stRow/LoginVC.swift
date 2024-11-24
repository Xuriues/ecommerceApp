//
//  LoginVC.swift
//  KangarooV1
//
//  Created by Shaun on 20/11/20.
//

import UIKit
import CoreData

class LoginVC: UIViewController {
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    var checkUser:[User] = []
    var productList = [ProductSports]()
    var flag = true
    @IBOutlet weak var passwordTxt: FloatingLabelInput!
    @IBOutlet weak var userTxt: FloatingLabelInput!
    @IBOutlet weak var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        getjsonData()
        setUpKeyBoard()
    }
    override func viewDidAppear(_ animated: Bool) {
        checkUser = []
        checkUser = getUserData()
    }
    @IBAction func dismissBtn(_ sender: UIBarButtonItem)
    {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let mainPage = main.instantiateViewController(identifier: "mainPage")
        self.present(mainPage , animated:true , completion: nil)

    }
    

    @IBAction func loginBtn(_ sender: UIButton)
    {
        if check(){
            for x in 0..<checkUser.count
            {
                if userTxt.text == checkUser[x].username && passwordTxt.text == checkUser[x].password
                {
                    flag = false
                    print("\(checkUser[x].username!), \(checkUser[x].id) \(checkUser[x].password!) All good")
                    id = Int(checkUser[x].id)
                    performSegue(withIdentifier: "homeTab", sender: self)
                }
            }
            if flag
            {
                Alert.loginFail(on: self)
            }
        }
        else
        {
            Alert.emptyField(on: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forgot"
        {
//            super.prepare(for: segue, sender: sender)
            self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)
            segue.destination.modalPresentationStyle = .custom
            segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
        }
        if segue.identifier == "homeTab"
        {
                let vc: mainTabBarController = segue.destination as! mainTabBarController
                vc.productList = productList
        }
    }
}
extension LoginVC
{
    func setUpKeyBoard()
    {
        userTxt.setBottomBorder()
        passwordTxt.setBottomBorder()
        self.userTxt.becomeFirstResponder()
        self.passwordTxt.becomeFirstResponder()
        self.hideKeyboardOnTapAround()
        
        let myColor = UIColor.gray
        
        
        btnLogin.setTitleColor(UIColor.darkGray, for: .normal)
        btnLogin.layer.borderWidth = 1
        btnLogin.backgroundColor = .clear
        btnLogin.layer.borderColor = myColor.cgColor
    }
    func check()->Bool
    {
        if userTxt.text != "" || passwordTxt.text != ""
        {
            return true
        }
        return false
    }
    func getjsonData()
    {
        
        //http://www.rajeshrmohan.com/clothing.json
        guard let url = URL(string:"http://www.rajeshrmohan.com/sport.json")
        else {return}
        let task = URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        guard let dataResponse = data,
        error == nil else {
        print(error?.localizedDescription ?? "Response Error")
            return
        }
            do{
                let decoder = JSONDecoder()
                let temp = try decoder.decode([ProductSports].self, from: dataResponse)
                self.productList = temp
                for x in 0..<temp.count
                {
                    print(temp[x].name)
                }
                DispatchQueue.main.async {
                
                }
            }
            catch let parsingError
            {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}
