//
//  cartCell.swift
//  KangarooV1
//
//  Created by Shaun on 27/11/20.
//

import UIKit

class cartCell: UITableViewCell {
    var currIndex = 0
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    var cart:[CartItems] = []
    var total:Double = 0
    var currentIndex:Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 100
        print(stepper.value)
        //stepper.value = Double(priceLbl.text!)!
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func changeQty(_ sender: UIStepper)
    {
        cart[currIndex].qty = Int16(stepper.value)
        cart[currIndex].totalprice = cart[currIndex].price * Double(stepper.value)
        priceLbl.text = "$ \(String(cart[currIndex].totalprice))"
        qtyLbl.text = "QTY: \(Int(stepper.value))"
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        print("Save")
        
    }
}

