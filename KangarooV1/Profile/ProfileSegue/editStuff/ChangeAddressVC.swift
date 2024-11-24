//
//  ChangeAddressVC.swift
//  KangarooV1
//
//  Created by Shaun on 20/11/20.
//

import UIKit
import CoreData
class ChangeAddressVC: UIViewController {
    var user = User()
    var unit:String = ""
    var add:String = ""
    var pos:String = ""
    let toolBar = UIToolbar()
    var addressPicker = UIPickerView()
    var forecast = [item]()
    var addressArray:[String] = []
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var unitnumTxt: FloatingLabelInput!
    @IBOutlet weak var postalTxt: FloatingLabelInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = getUser()
        setup()
        getArea()
        createPicker()
    }
    @IBAction func saveBtn(_ sender: UIButton)
    {
        if check(){
            var combineAddress = ""
            user.unitNum = unitnumTxt.text
            user.postalCode = postalTxt.text
            user.streetName = addressTxt.text
            combineAddress = "\(postalTxt.text!) \(addressTxt.text!) \(unitnumTxt.text!)"
            print(combineAddress)
            user.address = combineAddress
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            Alert.alertWithAction(on: self, with: "Successfully Updated", message: "Address has been updated.", nav: navigationController!)
        }
    }
}
extension ChangeAddressVC:  UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(addressArray.count)
        if addressArray.count == 0
        {
            return 0
        }
        return addressArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(addressArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if addressArray.count == 0
        {
            addressTxt.text = ""
        }
        else
        {
            addressTxt.text = String(addressArray[row])
            addressTxt.resignFirstResponder()
        }
    }
    
    func createPicker()
    {
        addressTxt.inputView = addressPicker
        addressPicker.delegate = self
        toolBar.sizeToFit()
        let donebutton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(hideKeyboard))
        toolBar.setItems([donebutton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.tintColor = .black
        toolBar.barTintColor = .gray
        addressTxt.inputAccessoryView = toolBar
    }
}
extension ChangeAddressVC
{
    func setup()
    {
        unitnumTxt.setBottomBorder()
        addressTxt.setBottomBorder()
        postalTxt.setBottomBorder()
        self.hideKeyboardOnTapAround()
        
        unitnumTxt.becomeFirstResponder()
        addressTxt.becomeFirstResponder()
        postalTxt.becomeFirstResponder ()
        if user.address == nil
        {
            unitnumTxt.text = ""
            addressTxt.text = ""
            postalTxt.text = ""
        }
        else
        {
            unitnumTxt.text = unit
            addressTxt.text = add
            postalTxt.text = pos
        }
    }
    func getArea()
    {
        addressArray.removeAll()
        guard let url = URL(string:
        "https://api.data.gov.sg/v1/environment/2-hour-weather-forecast")
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
                let model = try decoder.decode(Weather.self, from: dataResponse)
                print(model)
                for i in 0..<model.items[0].forecasts.count{
                    self.addressArray.append(model.items[0].forecasts[i].area)
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
    
    func check()->Bool
    {
        if unitnumTxt.text != "" && addressTxt.text != "" && postalTxt.text != ""
        {
            return true
        }
        else{Alert.emptyField(on: self)}
        return false
    }

}
