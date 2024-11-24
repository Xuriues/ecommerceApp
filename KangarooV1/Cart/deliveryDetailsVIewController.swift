//
//  deliveryDetailsVIewController.swift
//  KangarooV1
//
//  Created by Shaun on 28/11/20.
//
import UIKit
import MapKit
class deliveryDetailsVIewController: UIViewController,MKMapViewDelegate {
    var userInfo = User()
    var areaCoords = [area_metadata]()
    var area = [forecast]()
    @IBOutlet weak var barBtn: UIBarButtonItem!
    var totalPrice:Double = 0.0
    var locationIndex = 0
    var weather = ""
    var areaArray:[String] = []
    let LCManager = CLLocationManager()
    var addressPicker = UIPickerView()
    let toolBar = UIToolbar()
    var flag:Bool?
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var postalTxt: FloatingLabelInput!
    @IBOutlet weak var unitTxt: FloatingLabelInput!
    @IBOutlet weak var streetTxt: FloatingLabelInput!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getArea()
        LCManager.requestWhenInUseAuthorization()
        userInfo = getUser()
        setup()
        createPicker()
        mapView.delegate = self
        print(flag!)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        getArea()
        if userInfo.address != nil
        {
            mapView.removeAnnotations(mapView.annotations)
            setup()
            setupPinWhenLoad()
        }
    }
    
    
    
    func empty()->Bool
    {
        if unitTxt.text != "" && streetTxt.text != "" && postalTxt.text != ""
        {
            return true
        }
        else{Alert.emptyField(on: self)}
        return false
    }
    
    @IBAction func paymentPage(_ sender: UIButton)
    {
        if userInfo.address != nil
        {
            if userInfo.streetName != nil || userInfo.unitNum != nil || userInfo.postalCode != nil
            {
                if userInfo.streetName != streetTxt.text || userInfo.unitNum != unitTxt.text || userInfo.postalCode != postalTxt.text
                {
                    if empty()
                    {
                    let alert = UIAlertController(title: "Update", message: "We've updated your address details, go to profile to change.", preferredStyle: .alert)
                    let yes = UIAlertAction(title: "Yes", style: .default){(action) in
                        var combineAddress = ""
                        self.userInfo.unitNum = self.unitTxt.text
                        self.userInfo.postalCode = self.postalTxt.text
                        self.userInfo.streetName = self.streetTxt.text
                        combineAddress = "\(self.postalTxt.text!) \(self.streetTxt.text!) \(self.unitTxt.text!)"
                        print(combineAddress)
                        self.userInfo.address = combineAddress
                        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                        self.performSegue(withIdentifier: "paymentVC", sender: self)
                    }
                    alert.addAction(yes)
                    self.present(alert, animated: true, completion: nil)
                    }
                }
                self.performSegue(withIdentifier: "paymentVC", sender: self)
            }
            else
            {
                Alert.addressError(on: self)
            }
        }
        else
        {
            if empty()
            {
                let alert = UIAlertController(title: "Added New Address", message: "We have updated your address details, go to profile to change.", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Ok", style: .default){(action) in
                    var combineAddress = ""
                    self.userInfo.unitNum = self.unitTxt.text
                    self.userInfo.postalCode = self.postalTxt.text
                    self.userInfo.streetName = self.streetTxt.text
                    combineAddress = "\(self.postalTxt.text!) \(self.streetTxt.text!) \(self.unitTxt.text!)"
                    print(combineAddress)
                    self.userInfo.address = combineAddress
                    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                    self.performSegue(withIdentifier: "paymentVC", sender: self)
                }
                alert.addAction(yes)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func allowEdittiing(_ sender: UIBarButtonItem)
    {
        flag = !flag!
        if flag!{
            barBtn.image = UIImage(named: "doneIcon.png")
        }
        else
        {
            barBtn.image = UIImage(named: "editIcon.png")
        }
        streetTxt.isEnabled = !streetTxt.isEnabled
        unitTxt.isEnabled = !unitTxt.isEnabled
        postalTxt.isEnabled = !postalTxt.isEnabled
        print(flag!)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentVC"
        {
            let vc: CheckoutViewController = segue.destination as! CheckoutViewController
            vc.totalPrice = totalPrice
            vc.weatherDetails = weather
        }
    }
    

}
extension deliveryDetailsVIewController
{
    func setup()
    {
        postalTxt.setBottomBorder()
        streetTxt.setBottomBorder()
        unitTxt.setBottomBorder()
        self.hideKeyboardOnTapAround()
        totalPriceLbl.text = "Credits \(totalPrice)"
        postalTxt.becomeFirstResponder()
        streetTxt.becomeFirstResponder()
        unitTxt.becomeFirstResponder()
        
        if userInfo.address != nil
        {
            flag = false
            streetTxt.isEnabled = false
            unitTxt.isEnabled = false
            postalTxt.isEnabled = false
            postalTxt.text = userInfo.postalCode
            streetTxt.text = userInfo.streetName
            unitTxt.text = userInfo.unitNum
        }
        else
        {
            flag = true
            print("Oof")
        }

    }
    func getArea()
    {
        areaArray.removeAll()
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
                print("Hello \(model)")
                self.areaCoords = model.area_metadata
                self.area = model.items[0].forecasts
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
extension deliveryDetailsVIewController:  UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return area.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return area[row].area
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let anns = MKPointAnnotation()
        anns.coordinate = setPin(areaName: area[row].area)
        anns.title = area[row].area
        anns.subtitle = area[row].forecast
        weather = area[row].forecast
        print(weather)
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(anns)
        mapView.setCenter(anns.coordinate, animated: false)
        mapView.reloadInputViews()
        streetTxt.text = area[row].area
    }
    func setPin(areaName:String) -> CLLocationCoordinate2D{
        var location = CLLocationCoordinate2D()
        for x in 0..<areaCoords.count
        {
            if areaCoords[x].name == areaName
            {
                location = CLLocationCoordinate2D(latitude: Double(areaCoords[x].label_location.latitude) , longitude: Double(areaCoords[x].label_location.longitude))
//                print("latitude: \(Double(areaCoords[x].label_location.latitude)) , longitude: \(Double(areaCoords[x].label_location.longitude))")
            }
        }
        return location
    }
    func getweatherForcast(areaName: String)->String
    {
        var forcast = ""
        for x in 0..<area.count
        {
            if area[x].area == areaName
            {
                forcast = area[x].forecast
            }
        }
        return forcast
    }
    func setupPinWhenLoad()
    {
        let anns = MKPointAnnotation()
        anns.coordinate = setPin(areaName: userInfo.streetName!)
        anns.title = userInfo.streetName
        anns.subtitle = getweatherForcast(areaName: userInfo.streetName!)
        weather = getweatherForcast(areaName: userInfo.streetName!)
        mapView.addAnnotation(anns)
        mapView.setCenter(anns.coordinate, animated: false)
    }
    
    func createPicker()
    {
        streetTxt.inputView = addressPicker
        addressPicker.delegate = self
        toolBar.sizeToFit()
        let donebutton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(hideKeyboard))
        toolBar.setItems([donebutton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.tintColor = .black
        toolBar.barTintColor = .gray
        streetTxt.inputAccessoryView = toolBar
    }
}

