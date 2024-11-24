//
//  CartViewController.swift
//  KangarooV1
//
//  Created by Shaun on 27/11/20.
//

import UIKit
import CoreData
class CartViewController: UIViewController {
    @IBOutlet weak var nogLoginView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var totalpriceLbl: UILabel!
    var userCartItems:[CartItems] = []
    var cartCell:cartCell!
    var currUser = User()
    var vcTotal:Double = 0
    var imageArray:[UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        if id != nil
        {
            nogLoginView.isHidden = true
            currUser = getUser()
            userCartItems = showCartItems(id: currUser.id)
            totalPriceLabel(usercart: userCartItems, lbl: totalpriceLbl)
            updateCartBadge(cart: userCartItems, tabBar: tabBarController!)
            print(userCartItems.count)
            tableView.reloadData()
            if toProfileFlag{
                self.tabBarController?.selectedIndex = 0
                toProfileFlag = false
            }
            if userCartItems.count > 0
            {
                bigView.isHidden = true
            }
            else
            {
                bigView.isHidden = false
            }
        }
        else
        {
            nogLoginView.isHidden = false
            bottomView.isHidden = true
            tableView.isHidden = true
        }
    }
    @IBAction func btnTrash(_ sender: UIBarButtonItem)
    {
        tableView.isEditing = !tableView.isEditing
    }
    
    @IBAction func stepper(_ sender: UIStepper)
    {
        totalPriceLabel(usercart: userCartItems, lbl: totalpriceLbl)
    }
    
    
    @IBAction func proceedtoPayment(_ sender: UIButton)
    {
        if userCartItems.count > 0
        {
            performSegue(withIdentifier: "haveAddress", sender: self)
        }
        else{
            Alert.alertToGO(on: self, with: "Error", message: "Cart is empty. Add an item to continue.", tab: tabBarController!, index: 2, btnName: "Item Page")
        }
        
    }
    
    
}
extension CartViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCartItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cartCell
        cell.imgView.image = UIImage(data: userCartItems[indexPath.row].itemImage!)
        cell.nameLbl.text = userCartItems[indexPath.row].name
        cell.currIndex = indexPath.row
        cell.cart = userCartItems
        cell.stepper.value = Double(userCartItems[indexPath.row].qty)
        cell.priceLbl.text = "$\(userCartItems[indexPath.row].totalprice)"
        cell.qtyLbl.text = "QTY: \(userCartItems[indexPath.row].qty)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func delete(index:Int)
    {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            context.delete(userCartItems[index])
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(index: indexPath.row)
            userCartItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            totalPriceLabel(usercart: userCartItems, lbl: totalpriceLbl)
            updateCartBadge(cart: userCartItems, tabBar: tabBarController!)
            if userCartItems.count > 0
            {
                bigView.isHidden = true
            }
            else
            {
                bigView.isHidden = false
            }
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
    }
    
    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "haveAddress"
        {
            let vc : deliveryDetailsVIewController = segue.destination as! deliveryDetailsVIewController
            vc.totalPrice = vcTotal
        }
    }
    
}
extension CartViewController
{
    func setup()
    {
        if id != nil
        {
            nogLoginView.isHidden = true
            bottomView.isHidden = false
            tableView.isHidden = false
            currUser = getUser()
            userCartItems = showCartItems(id: currUser.id)
            totalPriceLabel(usercart: userCartItems, lbl: totalpriceLbl)
            tableView.reloadData()
            if userCartItems.count > 0
            {
                bigView.isHidden = true
            }
            else
            {
                bigView.isHidden = false
            }
        }
        else
        {
            nogLoginView.isHidden = false
            bottomView.isHidden = true
            tableView.isHidden = true
            tableView.reloadData()
        }
    }
    
    func totalPriceLabel(usercart:[CartItems],lbl:UILabel)
    {
        var numbers:[Double] = []
        var total:Double = 0
        for x in 0..<usercart.count
        {
            numbers.append(contentsOf: [usercart[x].totalprice])
            total = numbers.reduce(0, +)
        }
        vcTotal = total
        lbl.text = "Credits: \(total)"
    }
    
}

