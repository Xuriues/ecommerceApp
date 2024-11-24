//
//  sportVC.swift
//  KangarooV1
//
//  Created by Shaun on 25/11/20.
//

import UIKit

class sportVC: UIViewController {
    var itemList = [ProductSports]()
    var OGItem = [ProductSports]()
    var currIndex = 0
    var flagpHigh = false
    var flagpLow = false
    var alpha1Flag = false
    var alpha2Flag = false
    var currCell:sportCell!
    @IBOutlet weak var priceHighbtn: UIButton!
    @IBOutlet weak var priceLowbtn: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .mainBg
        filterView.isHidden = true
        setupBtn()
    }
    override func viewDidAppear(_ animated: Bool) {
        cellFlag = false
        if id != nil
        {
            var userCartItems:[CartItems] = []
            userCartItems = showCartItems(id: Int16(id!))
            updateCartBadge(cart: userCartItems, tabBar: tabBarController!)
        }
    }
    @IBAction func filterViewToggle(_ sender: UIBarButtonItem)
    {
        filterView.isHidden = !filterView.isHidden
        filterView.alpha = 1
        filterView.backgroundColor = UIColor.black.withAlphaComponent(0.90)
    }
    
    @IBAction func btnHigh(_ sender: UIButton)
    {
        flagpHigh = !flagpHigh
        if flagpHigh == true{
            self.itemList.sort(by: {$0.price > $1.price})
            collectionView.reloadData()
            priceHighbtn.layer.borderWidth = 3
        }
        else
        {
            itemList = OGItem
            if flagpHigh == false
            {
                priceHighbtn.layer.borderWidth = 1
            }
            priceLowbtn.layer.borderWidth = 1
            collectionView.reloadData()
        }
        print(flagpHigh)
        filterView.isHidden = true
        filterView.alpha = 0
        

    }
    @IBAction func btnLow(_ sender: UIButton)
    {
        flagpLow = !flagpLow
        if flagpLow == true{
            self.itemList.sort(by: {$0.price < $1.price})
            collectionView.reloadData()
            priceLowbtn.layer.borderWidth = 3
        }
        else
        {
            itemList = OGItem
            if flagpLow == false
            {
                priceLowbtn.layer.borderWidth = 1
            }
            priceHighbtn.layer.borderWidth = 1
            collectionView.reloadData()
        }
        print(flagpLow)
        filterView.isHidden = true
        filterView.alpha = 0
    }
    
    @IBAction func closeFilter(_ sender: UIButton)
    {
        itemList = OGItem
        setupBtn()
        collectionView.reloadData()
        filterView.isHidden = true
        filterView.alpha = 0
        flagpHigh = false
        flagpLow = false
        alpha1Flag = false
        alpha2Flag = false
    }
}
extension sportVC:UICollectionViewDataSource , UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! sportCell
        cell.nameLbl.text = itemList[indexPath.row].name
        cell.nameLbl.textAlignment = .center
        cell.priceLbl.text = "Credit: \(itemList[indexPath.row].price)"
        cell.priceLbl.textAlignment = .center
        cell.configure1(url: itemList[indexPath.row].image)
        if cell.img.image == nil
        {
            cell.indicator.startAnimating()
        }
        else
        {
            cell.indicator.stopAnimating()
        }
        setupCell(cell: cell)
        cell.layer.borderWidth = 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currIndex = indexPath.row
        currCell = collectionView.cellForItem(at: indexPath) as? sportCell
        performSegue(withIdentifier: "detailVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC"
        {
            let vc:detailVC = segue.destination as! detailVC
            cellFlag = true
            vc.desc = itemList[currIndex].description
            vc.cell = currCell
            vc.price = itemList[currIndex].price
            vc.productId = itemList[currIndex].id
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 1)
        UIView.animate(withDuration: 0.3,animations: {
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}
extension sportVC
{
    func setupBtn()
    {
        let myColor = UIColor.white
        priceHighbtn.layer.borderWidth = 1
        priceLowbtn.layer.borderWidth = 1
        
        priceLowbtn.backgroundColor = .clear
        priceHighbtn.backgroundColor = .clear

        priceHighbtn.layer.borderColor = myColor.cgColor
        priceLowbtn.layer.borderColor = myColor.cgColor
    }
}
