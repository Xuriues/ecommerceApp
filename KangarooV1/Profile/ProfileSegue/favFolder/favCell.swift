//
//  favCell.swift
//  KangarooV1
//
//  Created by Shaun on 8/12/20.
//

import UIKit
protocol alertPop {
    func showAlert(itemID:String, userID:Int16, index:Int)
}
protocol alertPop2 {
    func showAlert2(itemID: String, userID: Int16, index: Int)
}
class favCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    var currIndex = 0
    var cartItems:[CartItems] = []
    var getItem:[FavData] = []
    var delegate: alertPop!
    var delegate2: alertPop2!
    var currUser = User()
    var tabBar:UITabBarController!
    var tableView:UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    @IBAction func btnAdd(_ sender: UIButton)
    {
        cartItems = getAllCartItem()
        print(cartItems.count)
        if checkUnique(){
            self.delegate2.showAlert2(itemID: getItem[currIndex].itemID!, userID: currUser.id, index: currIndex)
        }
        else
        {
            addToCart()
            self.delegate.showAlert(itemID: getItem[currIndex].itemID!, userID: currUser.id, index: currIndex)
        }
        tableView.reloadData()
        print("\(currIndex)")
    }
    func getAllCartItem()->[CartItems]
    {
        var cart:[CartItems] = []
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
                let data = try? context.fetch(CartItems.fetchRequest())
                let array = data as! [CartItems]
            for x in 0..<array.count
            {
                if array[x].userID == currUser.id
                {
                    cart.append(array[x])
                }
            }
        }
        return cart
    }
    
    func addToCart()
    {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let newData = CartItems(context: context)
            newData.itemId = getItem[currIndex].itemID
            newData.itemDescription = getItem[currIndex].itemDescription
            newData.itemImage = getItem[currIndex].itemImage
            newData.name = getItem[currIndex].itemName
            newData.price = getItem[currIndex].itemPrice
            newData.totalprice = getItem[currIndex].itemPrice
            newData.userID = currUser.id
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            tableView.reloadData()
            if cartItems.count < 1
            {
                tabBar.tabBar.items?[3].badgeValue = String(cartItems.count+1)
            }
            else
            {
                tabBar.tabBar.items?[3].badgeValue = String(cartItems.count+1)
            }
            print("Item added to cart")
        }
    }
    func checkUnique()->Bool
    {
        for x in 0..<cartItems.count
        {
            if cartItems[x].itemId == getItem[currIndex].itemID && cartItems[x].userID == currUser.id
            {
                cartItems[x].qty += 1
                cartItems[x].totalprice = cartItems[x].price * Double(cartItems[x].qty)
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                print("Quantity : \(cartItems[x].qty) for \(cartItems[x].userID)")
                return true
            }
        }
        return false
    }
}
