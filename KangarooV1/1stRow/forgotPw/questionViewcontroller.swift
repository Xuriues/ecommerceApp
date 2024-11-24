//
//  questionViewcontroller.swift
//  KangarooV1
//
//  Created by Shaun on 5/12/20.
//

import UIKit

class questionViewcontroller: UIViewController {
    var user = User()
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var answerTxt: FloatingLabelInput!
    override func viewDidLoad() {
        super.viewDidLoad()
        answerTxt.setBottomBorder()
        hideKeyboardOnTapAround()
        questionLbl.text = user.question
    }
    
    func setup()
    {
        let myColor = UIColor.gray
        
        
        nextBtn.setTitleColor(UIColor.darkGray, for: .normal)
        nextBtn.layer.borderWidth = 1
        nextBtn.backgroundColor = .clear
        nextBtn.layer.borderColor = myColor.cgColor
    }
    @IBAction func btnForward(_ sender: UIButton)
    {
        if answerTxt.text != ""
        {
            if user.answer == answerTxt.text
            {
                performSegue(withIdentifier: "view2", sender: self)
            }
            else
            {
                Alert.wrongAnswer(on: self)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "view2"
        {
            let vc: UpdatePasswordViewController = segue.destination as! UpdatePasswordViewController
            vc.user = user
        }
    }
}
