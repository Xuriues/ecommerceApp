//
//  detailVC.swift
//  KangarooV1
//
//  Created by Shaun on 26/11/20.
//

import UIKit
import CoreData
class detailVC: UIViewController {
    var desc:String = ""
    var price:Double = 0
    var name:String = ""
    @IBOutlet weak var favIcon: UIBarButtonItem!
    var image:UIImage!
    var productId = ""
    var productFromTbl = [ProductSports]()
    var currUser = User()
    var cell:sportCell!
    var cartItems:[CartItems] = []
    var favItems:[FavData] = []
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var addtoCart: UIButton!
    @IBOutlet weak var descripLabel: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var nameLBl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addTopAndBottomBorders()
        currUser = getUser()
        cartItems = getAllCartItem()
        favItems = getAllFavItems()
        if id == nil
        {
            print("Not login")
        }
        else
        {
            print(currUser.id)
        }
        if tblFlag
        {
                loadTbl()
                print(productId)
            tblFlag = false
        }
        else if cellFlag
        {
                loadCC()
                print(productId)
                cellFlag = false
        }
        if checkIfHeart()
        {
            favIcon.image = UIImage(named: "heartIcon.png")
        }
        else
        {
            favIcon.image = UIImage(named: "holoHeartIcon.png")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if imgView.image == nil
        {
            indicator.startAnimating()
        }
        else
        {
            indicator.stopAnimating()
        }
    }
    
    @IBAction func addToFav(_ sender: UIBarButtonItem)
    {
        if id == nil
        {
            Alert.alertToGO(on: self, with: "Error", message: "You must login to purchase item.", tab: tabBarController!, index: 0, btnName: "Login/Sign Up")
        }
        else
        {
            if imgView.image != nil
            {
                if checkIfHeart()
                {
                    let alert = UIAlertController(title: "Delete?", message: "You've already added this item to your favourite list do you want to delete it from your list?", preferredStyle: .alert)
                    
                    let yes = UIAlertAction(title: "Yes", style: .default){(action) in
                        self.deleteByFavList(userid: self.currUser.id, itemID: self.productId)
                        self.favIcon.image = UIImage(named: "holoHeartIcon.png")
                    }
                    let no = UIAlertAction(title: "No", style: .destructive)
                    alert.addAction(yes)
                    alert.addAction(no)
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    addtoFav(id: productId, pName: nameLBl.text!, pDes: descripLabel.text!, pPrice: price,img: Data((imgView.image?.pngData())!) ,userid: currUser.id)
                    let alert = UIAlertController(title: "Added", message: "Added to favourite.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default){(action) in
                        self.favIcon.image = UIImage(named: "heartIcon.png")
                    })
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func addToCart(_ sender: UIButton)
    {
        if id == nil
        {
            Alert.alertToGO(on: self, with: "Error", message: "You must login to purchase item.", tab: tabBarController!, index: 0, btnName: "Login/Sign Up")
        }
        else
        {
            if imgView.image != nil
            {
                if checkUnique(){
                    Alert.alertWithAction(on: self, with: "Item is already in cart", message: "We have increase the quantity for you!.", nav: navigationController!)
                }
                else
                {
                    addToCart(id: productId, pName: nameLBl.text!, pDes: descripLabel.text!, pPrice: price,img: Data((imgView.image?.pngData())!) ,userid: currUser.id, tPrice: price)
                    let alert = UIAlertController(title: "Added to cart.", message: "Item has been added to cart.", preferredStyle: .alert)
                    let goToCart = UIAlertAction(title: "Go to Cart", style: .default){(action) in
                        self.navigationController?.popViewController(animated: true)
                        self.tabBarController?.selectedIndex = 3
                    }
                    let continueShopping = UIAlertAction(title: "Continue Shopping", style: .default){(action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(goToCart)
                    alert.addAction(continueShopping)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                Alert.alertWithAction(on: self, with: "Error", message: "Problem loading product data please try again later. Or wait for the data to load.", nav: navigationController!)
            }
        }
    }
    func checkUnique()->Bool
    {
        for x in 0..<cartItems.count
        {
            if cartItems[x].itemId == productId && cartItems[x].userID == currUser.id
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
    
    func checkIfHeart()->Bool
    {
        for x in 0..<favItems.count
        {
            if favItems[x].itemID == productId && favItems[x].userID == currUser.id
            {
                return true
            }
        }
        return false
    }
}
extension detailVC{
    func addTopAndBottomBorders() {
       let thickness: CGFloat = 2.0
       let topBorder = CALayer()
       let bottomBorder = CALayer()
       topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.nameLBl.frame.size.width, height: thickness)
        topBorder.backgroundColor = UIColor.black.cgColor
        topBorder.opacity = 0.3
       bottomBorder.frame = CGRect(x:0, y: self.nameLBl.frame.size.height - thickness, width: self.nameLBl.frame.size.width, height:thickness)
       bottomBorder.backgroundColor = UIColor.black.cgColor
        bottomBorder.opacity = 0.2
        nameLBl.layer.addSublayer(topBorder)
        nameLBl.layer.addSublayer(bottomBorder)
    }
    func loadCC()
    {
        self.imgView.image = cell.img.image
        self.nameLBl.text = cell.nameLbl.text
        self.priceLbl.text = "Price: $\(price)"
        self.descripLabel.text = desc
    }
    func loadTbl()
    {
        self.configure2(url: productFromTbl[0].image)
        self.nameLBl.text = productFromTbl[0].name
        price = productFromTbl[0].price
        self.priceLbl.text = "Credits: \(productFromTbl[0].price)"
        self.descripLabel.text = productFromTbl[0].description
        self.productId = productFromTbl[0].id
    }
    
    func configure2(url text:String)
    {
        guard let url = URL(string: text) else { return }
        if let image = imageCacheCC.object(forKey: NSString(string :text))
        {
            self.imgView.image = image
        }
        else
        {
            let task:URLSessionDataTask = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
                do{
                    if let data = data,
                       let image = UIImage(data: data)
                    {
                        imageCacheCC.setObject(image, forKey: NSString(string: text))
                        DispatchQueue.main.async
                        {
                            self.imgView.image = image
                            print("Added")
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
