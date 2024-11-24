//
//  CheckoutViewController.swift
//  KangarooV1
//
//  Created by Shaun on 29/11/20.
//

import UIKit
var flagtoDiscount = true
class CheckoutViewController: UIViewController {
    var insertArray :[[String]] = []
    var userInfo = User()
    var userCartItems:[CartItems] = []
    var discount:Int = 0
    var weatherDetails = ""
    var totalPrice:Double = 0.0
    var totalPriceAfterDiscount:Double = 0
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        userInfo = getUser()
        userCartItems = showCartItems(id: userInfo.id)
        print(weatherDetails)
        tableView.delegate = self
        tableView.dataSource = self
        totalPriceLbl.text = "Credits: \(totalPrice)"
        lblAddress.text = userInfo.address
        lblDelivery.text = checkifRain()
        if flagtoDiscount{
            Alert.discountMsg(on: self)
        }
        else
        {
            Alert.wastedShake(on: self)
        }
    }
    
    
    @IBAction func btnCheckout(_ sender: UIButton)
    {
        if userInfo.credit > totalPrice
        {
            flagtoDiscount = true
            minusOffCredit()
            runLoop()
            goToProfile()
        }
        else
        {
            Alert.notEnough(on: self)
        }
    }
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if flagtoDiscount{
            if motion == .motionShake
            {
                discount = Int.random(in: 0...20)
                discountLbl.text = "\(discount)%"
                print(discount)
                flagtoDiscount = false
                minusDiscount()
            }
        }
        else
        {
            Alert.cannotShake(on: self)
        }
    }
}
extension CheckoutViewController: UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! checkoutItemCell
        cell.img.image = UIImage(data: userCartItems[indexPath.row].itemImage!)
        cell.nameLbl.text = userCartItems[indexPath.row].name
        cell.qtyLabel.text = "QTY: \(userCartItems[indexPath.row].qty)"
        cell.creditLbl.text = "Credits: \(userCartItems[indexPath.row].totalprice)"
        return cell
    }
}
extension CheckoutViewController
{
    
    func checkifRain()->String
    {
        var msg = ""
        if weatherDetails == "Showers" || weatherDetails == "Thundery Showers" || weatherDetails == "Light Rain" || weatherDetails == "Rain" || weatherDetails == "Heavy Rain"
        {
            msg = "Your items will be delivered tomorrow"
        }
        else
        {
            msg = "Item will be delivered today."
        }
        return msg
    }
    
    func minusDiscount(){
        var discountInDouble:Double = 0
        discountInDouble = (Double(discount) / 100) * totalPrice
        totalPrice = totalPrice - discountInDouble
        totalPriceLbl.text = String(format: "%.2f", totalPrice)
        print(discountInDouble)
    }
    func minusOffCredit()
    {
        userInfo.credit -= totalPrice
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        print("Save")
    }
    
    func runLoop()
    {
        let randomNumber = Int64(arc4random_uniform(900000)+1000000000)
        for x in 0..<userCartItems.count
        {
            addToOrder(userID: userCartItems[x].userID, itemName: userCartItems[x].name!, tPrice: userCartItems[x].totalprice, pQTY: userCartItems[x].qty, userItem: userCartItems, randomNum: randomNumber)
        }
        deleteCarItemsByID(id: userInfo.id)
    }
    
    
    func goToProfile()
    {
        let alert = UIAlertController(title: "Successfully purchased.", message: "You have purhcased the items go to profile to check summarys.", preferredStyle: .alert)
        let profile = UIAlertAction(title: "Profile", style: .default){(action) in
            self.navigationController!.popToRootViewController(animated: true)
            toProfileFlag = true
        }
        let ok = UIAlertAction(title: "Ok", style: .default){(action) in
            self.navigationController!.popToRootViewController(animated: true)
        }
        alert.addAction(profile)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
}
