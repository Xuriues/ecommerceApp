//
//  orderSummeryCell.swift
//  KangarooV1
//
//  Created by Shaun on 1/12/20.
//

import UIKit

class orderSummeryCell: UITableViewCell {

    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
