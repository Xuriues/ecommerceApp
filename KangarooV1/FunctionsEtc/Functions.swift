//
//  Functions.swift
//  KangarooV1
//
//  Created by Shaun on 20/11/20.
//
import Foundation
import UIKit
import CoreData
var id:Int?
var tblFlag = false
var cellFlag = false
var toProfileFlag = false
extension UIViewController
{
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.range(of: emailRegEx, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    func hideKeyboardOnTapAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func getUserData()->[User]
    {
        var user = [User]()
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let data = try? context.fetch(User.fetchRequest())
            user = data as! [User]
        }
        return user
    }

    
    func setData(user:String,pass:String,name:String,lastName:String,contact:Int32,email:String,ques:String,ans:String,entity:[User])
    {
        var id = 0
        print(user.count)
        if entity.count > 0
        {
            id = Int(entity[entity.count-1].id) + 1
        }
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let newData = User(context: context)
            newData.id = Int16(id)
            newData.name = name
            newData.lastName = lastName
            newData.username = user
            newData.password = pass
            newData.contact = contact
            newData.email = email
            newData.question = ques
            newData.answer = ans
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
    }
    func getUser()->User
    {
        var target = User()
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let data = try? context.fetch(User.fetchRequest())
            let user = (data as? [User])!
            for x in 0..<user.count
            {
                if Int(user[x].id) == id
                {
                    target = user[x]
                }
            }
        }
        return target
    }
    
    func addToCart(id:String,pName:String,pDes:String,pPrice:Double,img:Data,userid:Int16,tPrice:Double)
    {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let newData = CartItems(context: context)
            newData.itemId = id
            newData.name = pName
            newData.itemImage = img
            newData.itemDescription = pDes
            newData.price = pPrice
            newData.userID = userid
            newData.totalprice = tPrice
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            print("Added to cart dataBase")
        }
    }
    func addToOrder(userID:Int16, itemName:String, tPrice:Double, pQTY:Int16, userItem:[CartItems], randomNum: Int64)
    {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let newData = OrderCart(context: context)
            newData.userID = userID
            newData.itemName = itemName
            newData.itemPrice = tPrice
            newData.qty = pQTY
            if userItem.count > 1
            {
                print(randomNum)
                newData.orderID = randomNum
            }
            else
            {
                newData.orderID = Int64(arc4random_uniform(900000)+1000000000)
            }
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
    }
    
    func deleteCarItemsByID(id:Int16)
    {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let data = try? context.fetch(CartItems.fetchRequest())
            for x in data as! [CartItems]
            {
                if x.userID == id
                {
                    context.delete(x)
                }
            }
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            print("Item deleted")
        }
    }
    
    func deleteByFavList(userid:Int16, itemID:String)
    {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let data = try? context.fetch(FavData.fetchRequest())
            for x in data as! [FavData]
            {
                if x.userID == userid && x.itemID == itemID
                {
                    context.delete(x)
                }
            }
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            print("Item deleted")
        }
    }
    
    func showCartItems(id:Int16)->[CartItems]
    {
        var userCart:[CartItems] = []
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let data = try? context.fetch(CartItems.fetchRequest())
            let array = data as! [CartItems]
            for x in 0..<array.count
            {
                if array[x].userID == id
                {
                    userCart.append(array[x])
                }
            }
        }
        return userCart
    }
    
    func showFavList(id:String)->[FavData]
    {
        var list:[FavData] = []
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let fetchReq:NSFetchRequest<NSFetchRequestResult> = FavData.fetchRequest()
            fetchReq.predicate = NSPredicate(format: "userID == %@", id)
            let data = try? context.fetch(fetchReq)
            let array = data as! [FavData]
            if array.count > 0
            {
                for x in 0..<array.count
                {
                    list.append(array[x])
                }
            }
            else
            {
                print("Empty")
            }
        }
        return list
    }

    
    func getAllCartItem()->[CartItems]
    {
        var cart:[CartItems] = []
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
                let data = try? context.fetch(CartItems.fetchRequest())
                cart = data as! [CartItems]
        }
        return cart
    }
    

    func getAllFavItems()->[FavData]
    {
        var favList:[FavData] = []
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
                let data = try? context.fetch(FavData.fetchRequest())
                favList = data as! [FavData]
        }
        return favList
    }
    
    
    func addtoFav(id:String,pName:String,pDes:String,pPrice:Double,img:Data,userid:Int16)
    {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let newData = FavData(context: context)
            newData.itemID = id
            newData.itemName = pName
            newData.itemDescription = pDes
            newData.itemPrice = pPrice
            newData.itemImage = img
            newData.userID = userid
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            print("\(id) is added to fav list of \(userid)")
        }
    }

    func getAllOrders()->[OrderCart]
    {
        var cart:[OrderCart] = []
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
                let data = try? context.fetch(OrderCart.fetchRequest())
                cart = data as! [OrderCart]
        }
        return cart
    }
    
    func getOrder()->[OrderCart]{
        var orderList = [OrderCart]()
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let data = try? context.fetch(OrderCart.fetchRequest())
            let currOrder = data as! [OrderCart]
            for x in 0..<currOrder.count
            {
                if currOrder[x].userID == id!
                {
                    orderList.append(currOrder[x])
                }
            }
        }
        return orderList
    }
    func updateCartBadge(cart:[CartItems], tabBar:UITabBarController)
    {
        if cart.count > 0
        {
            tabBar.tabBar.items?[3].badgeValue = String(cart.count)
        }
        else
        {
            tabBar.tabBar.items?[3].badgeValue = nil
        }
    }
    
    func getOrderByID(orderID:Int64)->[OrderCart]
    {
        var orderCart:[OrderCart] = []
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let data = try? context.fetch(OrderCart.fetchRequest())
            let array = data as! [OrderCart]
            for x in 0..<array.count
            {
                if array[x].orderID == orderID && array[x].userID == id!
                {
                    orderCart.append(array[x])
                }
            }
        }
        return orderCart
    }
}
