//
//  orderSummeryVC.swift
//  KangarooV1
//
//  Created by Shaun on 1/12/20.
//

import UIKit

class orderSummeryVC: UIViewController {
    var orderArray:[OrderCart] = []
    var userInfo = User()
    var userInfoArray:[[String]] = []
    var orderid:Int64 = 0
    @IBOutlet weak var orderidLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfo = getUser()
        tableView.delegate = self
        tableView.dataSource = self
        orderidLbl.text =  String(orderid)
        orderArray = getOrderByID(orderID: orderid)
        print(orderArray.count)
    }
}
extension orderSummeryVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return orderArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! orderSummeryCell
        cell.lblName.text = orderArray[indexPath.row].itemName
        cell.qtyLbl.text = "QTY: \(orderArray[indexPath.row].qty)"
        cell.priceLbl.text = "Credits: \(orderArray[indexPath.row].itemPrice)"
        return cell
    }


}
