//
//  favViewController.swift
//  KangarooV1
//
//  Created by Shaun on 8/12/20.
//

import UIKit
import CoreData
class favViewController: UIViewController {
    var list:[FavData] = []
    var user = User()
    var cartItems:[CartItems] = []
    var cellSelected:favCell?
    var userCartItems:[CartItems] = []
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lbl:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        user = getUser()
        list = showFavList(id: String(user.id))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cartItems = getAllCartItem()
        list = showFavList(id: String(user.id))
        userCartItems = showCartItems(id: Int16(id!))
        updateCartBadge(cart: userCartItems, tabBar: tabBarController!)
        if list.count > 0
        {
            imgView.isHidden = true
            lbl.isHidden = true
        }
        else
        {
            imgView.isHidden = false
            lbl.isHidden = false
        }
        tableView.reloadData()
    }

    @IBAction func btnDelete(_ sender: UIBarButtonItem)
    {
        tableView.isEditing = !tableView.isEditing
    }

}
extension favViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! favCell
        cell.currIndex = indexPath.row
        cell.getItem = list
        cell.currUser = user
        cell.cartItems = cartItems
        cell.tableView = tableView
        cell.tabBar = tabBarController
        cell.nameLbl.text = list[indexPath.row].itemName
        cell.priceLbl.text = "Credits: \(list[indexPath.row].itemPrice)"
        cell.imgView.image = UIImage(data: list[indexPath.row].itemImage!)
        cell.delegate = self
        cell.delegate2 = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func delete(index:Int)
    {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            context.delete(list[index])
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(index: indexPath.row)
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateCartBadge(cart: userCartItems, tabBar: tabBarController!)
            if list.count > 0
            {
                imgView.isHidden = true
                lbl.isHidden = true
            }
            else
            {
                imgView.isHidden = false
                lbl.isHidden = false
            }
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
    }
}
extension favViewController:  alertPop, alertPop2
{
    func showAlert2(itemID: String, userID: Int16, index: Int) {
        let alert = UIAlertController(title: "Quantity", message: "You already have this item in your cart, quantity shall be increased. Forgot to delete item? Do you want to delete it from list?", preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yes = UIAlertAction(title: "Yes", style: .default){(action) in
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            {
                let data = try? context.fetch(FavData.fetchRequest())
                for x in data as! [FavData]
                {
                    if x.itemID == itemID && x.userID == userID
                    {
                        context.delete(x)
                    }
                }
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                print("Item deleted")
            }
            self.list.remove(at: index)
        }
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
    func showAlert(itemID: String, userID: Int16, index: Int) {
        let alert = UIAlertController(title: "Added", message: "Item has been added to cart do you want to remove this item from favourite list?", preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .destructive, handler: nil)
        let yes = UIAlertAction(title: "Yes", style: .default){(action) in
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            {
                let data = try? context.fetch(FavData.fetchRequest())
                for x in data as! [FavData]
                {
                    if x.itemID == itemID && x.userID == userID
                    {
                        context.delete(x)
                    }
                }
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                print("Item deleted")
            }
            self.list.remove(at: index)
            self.tableView.reloadData()
        }
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
}
