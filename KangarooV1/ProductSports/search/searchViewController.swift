//
//  searchViewController.swift
//  KangarooV1
//
//  Created by Shaun on 26/11/20.
//

import UIKit

class searchViewController: UIViewController {
    @IBOutlet weak var filterView: UIView!
    var searchItemList = [ProductSports]()
    var filterData : [ProductSports]!
    var currProduct = [ProductSports]()
    @IBOutlet weak var alphaAsc: UIButton!
    @IBOutlet weak var alphaDesc: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        filterView.isHidden = true
        setup()
        searchBar.barTintColor = .mainBg
        tableview.backgroundColor = .mainBg
        filterData = searchItemList
    }
    @IBAction func filterViewShow(_ sender: UIBarButtonItem)
    {
        filterView.isHidden = !filterView.isHidden
        filterView.alpha = 1
        filterView.backgroundColor = UIColor.black.withAlphaComponent(0.90)

    }
    var alpha1Flag = false
    var alpha2Flag = false
    @IBAction func alphaAsc(_ sender: UIButton)
    {
        alpha1Flag = !alpha1Flag
        if alpha1Flag == true{
            self.filterData.sort(by: {$0.name < $1.name})
            tableview.reloadData()
            alphaAsc.layer.borderWidth = 3
        }
        else
        {
            filterData = searchItemList
            if alpha1Flag == false
            {
                alphaAsc.layer.borderWidth = 1
            }
            alphaDesc.layer.borderWidth = 1
            tableview.reloadData()
        }
        print(alpha1Flag)
        filterView.isHidden = true
        filterView.alpha = 0
    }
    
    @IBAction func alphaDesc(_ sender: Any)
    {
        alpha2Flag = !alpha2Flag
        if alpha2Flag == true{
            self.filterData.sort(by: {$0.name > $1.name})
            tableview.reloadData()
            alphaDesc.layer.borderWidth = 3
        }
        else
        {
            filterData = searchItemList
            if alpha2Flag == false
            {
                alphaDesc.layer.borderWidth = 1
            }
            alphaAsc.layer.borderWidth = 1
            tableview.reloadData()
        }
        print(alpha1Flag)
        filterView.isHidden = true
        filterView.alpha = 0
    }
    
    @IBAction func resetFilter(_ sender: UIButton)
    {
        filterData = searchItemList
        setup()
        tableview.reloadData()
        filterView.isHidden = true
        filterView.alpha = 0
        alpha1Flag = false
        alpha2Flag = false
    }
    

}
extension searchViewController: UITableViewDelegate , UITableViewDataSource
{
    override func viewDidAppear(_ animated: Bool) {
        tblFlag = false
        if id != nil
        {
            var userCartItems:[CartItems] = []
            userCartItems = showCartItems(id: Int16(id!))
            updateCartBadge(cart: userCartItems, tabBar: tabBarController!)
        }
    }
    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filterData.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .mainBg
        cell.selectedBackgroundView?.backgroundColor = .white
        cell.layer.opacity = 0.5
        cell.textLabel?.text = filterData[indexPath.row].name
        return cell
    }
    

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currProduct = [filterData[indexPath.row]]
        performSegue(withIdentifier: "detailVC", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0, y: 0 )
        UIView.animate(withDuration: 0.5, delay: 0.01 * Double(indexPath.row),animations: {
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC"
        {
            let vc : detailVC = segue.destination as! detailVC
            tblFlag = true
            vc.productFromTbl = currProduct
        }
    }
}
extension searchViewController
{
    func setup()
    {
        let myColor = UIColor.white
        alphaDesc.layer.borderWidth = 1
        alphaAsc.layer.borderWidth = 1
        alphaAsc.backgroundColor = .clear
        alphaDesc.backgroundColor = .clear
        alphaAsc.layer.borderColor = myColor.cgColor
        alphaDesc.layer.borderColor = myColor.cgColor
    }
}
extension searchViewController: UISearchBarDelegate, UISearchTextFieldDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""
        {
            filterData = searchItemList
            self.tableview.reloadData()
        }
        else
        {
            filterData = [ProductSports]()
            for x in 0..<searchItemList.count
            {
                if searchItemList[x].name.lowercased().contains(searchText.lowercased())
                {
                    filterData.append(searchItemList[x])
                }
            }
            self.tableview.reloadData()
        }
    }
}
