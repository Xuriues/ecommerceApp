//
//  checkoutItemCell.swift
//  KangarooV1
//
//  Created by Shaun on 29/11/20.
//

import UIKit

class checkoutItemCell: UITableViewCell {
    
    
    @IBOutlet weak var creditLbl: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
