//
//  ProfileViewController.swift
//  KangarooV1
//
//  Created by Shaun on 20/11/20.
//

import UIKit
import CoreData
class ProfileViewController: UIViewController {
    var user = User()
    var index = 0
    var barButton: UIBarButtonItem!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var array:[String] = []
    var insertArray: [[String]] = []
    var userCartItems:[CartItems] = []
    var userOrder:[OrderCart] = []
    var activityIndicatorView: ActivityIndicatorView!
    @IBOutlet weak var welcomebackView: UIView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notLoginView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if id != nil
        {
            tableView.alpha = 0.5
            welcomebackView.alpha = 0.5
            self.activityIndicatorView = ActivityIndicatorView(title: "Fetching data...", center: self.view.center)
            self.view.addSubview(self.activityIndicatorView.getViewActivityIndicator())
            self.activityIndicatorView.startAnimating()
            userOrder = getOrder()
            userCartItems = showCartItems(id: Int16(id!))
            welcomebackView.isHidden = false
            notLoginView.isHidden = true
            tableView.isHidden = false
            user = getUser()
            setup()
        }
        else
        {
            welcomebackView.isHidden = true
            notLoginView.isHidden = false
            tableView.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if id != nil
        {
            userCartItems = showCartItems(id: Int16(id!))
            updateCartBadge(cart: userCartItems, tabBar: tabBarController!)
            welcomebackView.isHidden = false
            notLoginView.isHidden = true
            view.isHidden = false
            user = getUser()
            userOrder = getOrder()
            setUpArray()
            setup()
            usernameLbl.text = user.username!
            tableView.reloadData()
            barButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(loginTrue))
            self.barButton.image = UIImage(named: "logoutIcon.png")
            self.barButton.tintColor = .black
            self.navigationItem.rightBarButtonItem = barButton
            self.activityIndicatorView.stopAnimating()
            tableView.alpha = 1
            welcomebackView.alpha = 1
        }
        else
        {
            welcomebackView.isHidden = true
            notLoginView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    
    // MARK: - Functions
    
    @objc func loginTrue()
    {
        let alert = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default){(action) in
            id = nil
            flagtoDiscount = true
            let main = UIStoryboard(name: "Main", bundle: nil)
            let loginPage = main.instantiateViewController(identifier: "mainPage")
            self.present(loginPage , animated:true , completion: nil)
        }
        let no = UIAlertAction(title: "No", style: .destructive)
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
    func setUpArray()
    {
        insertArray.removeAll()
        insertArray.append(["Credits:","You have \(Int(user.credit)) credits left."])
        insertArray.append(["Change Account Details", "Button"])
        insertArray.append(["Details:","\(user.name!) \(user.lastName!)\n\(user.email!)\n\(user.contact)"])
        insertArray.append(["Change Personal Details", "Button"])
        insertArray.append(["Address", emptyAddress()])
        insertArray.append(["Edit Address", "Button"])
        insertArray.append(["Favourite","View"])
    }
    func loop()->[String]
    {
        array.removeAll()
        for x in 0..<userOrder.count
        {
            array.append(String(userOrder[x].orderID))
        }
        return array
    }
    func setup()
    {
        let array = loop()
        var sortData:[String] = []
        sortData = array.removingDuplicates()
        for x in 0..<sortData.count
        {
            insertArray.append(["Order Id: ","\(sortData[x])"])
        }
    }
    func emptyAddress()->String
    {
        if user.address == nil
        {
            return "No address has been registered"
        }
        else
        {
            return user.address!
        }
    }
    var detailPerson = User()
    var addressPerson = User()
}
extension ProfileViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return insertArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(insertArray[indexPath.row][1] == "Button")
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = insertArray[indexPath.row][0]
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .black
            cell.textLabel?.alpha = 0.75
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        if(insertArray[indexPath.row][1] == "View")
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = insertArray[indexPath.row][0]
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! customCellProfile
        cell.detailLbl.text = insertArray[indexPath.row][0]
        cell.subLbl.text = "\(insertArray[indexPath.row][1])"
        cell.subLbl.textColor = .gray
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1
        {
            performSegue(withIdentifier: "accDetails", sender: self)
        }
        else if indexPath.row == 3
        {
            detailPerson = user
            performSegue(withIdentifier: "personalDetails", sender: self)
        }
        else if indexPath.row == 5
        {
            addressPerson = user
            performSegue(withIdentifier: "changeAddress", sender: self)
        }
        else if indexPath.row == 6
        {
            performSegue(withIdentifier: "showFav", sender: self)
        }
        else if indexPath.row > 6
        {
            index = indexPath.row
            performSegue(withIdentifier: "orderView", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "personalDetails")
        {
            let vc : ChangePersonalDetailsVC = segue.destination as! ChangePersonalDetailsVC
            vc.userName = detailPerson.name!
            vc.userLastname = detailPerson.lastName!
            vc.userContact = detailPerson.contact
            vc.userEmail = detailPerson.email!
        }
        else if (segue.identifier == "changeAddress")
        {
            let vc : ChangeAddressVC = segue.destination as! ChangeAddressVC
            if user.address == nil
            {
                vc.unit = ""
                vc.add = ""
                vc.pos = ""
            }
            else
            {
                vc.unit = user.unitNum!
                vc.add = user.streetName!
                vc.pos = user.postalCode!
            }
        }
        else if (segue.identifier == "orderView")
        {
            let vc: orderSummeryVC = segue.destination as! orderSummeryVC
            vc.orderid = Int64(insertArray[index][1])!
        }
     }
}
extension Array where Element: Equatable {
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}
