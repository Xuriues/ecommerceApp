//
//  ViewController.swift
//  KangarooV1
//
//  Created by Shaun on 20/11/20.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    var productList = [ProductSports]()
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
//        deleteAll()
        getjsonData()
    }
    func getjsonData()
    {
        
        //http://www.rajeshrmohan.com/clothing.json
        guard let url = URL(string:"http://www.rajeshrmohan.com/sport.json")
        else {return}
        let task = URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        guard let dataResponse = data,
        error == nil else {
        print(error?.localizedDescription ?? "Response Error")
            return
        }
            do{
                let decoder = JSONDecoder()
                let temp = try decoder.decode([ProductSports].self, from: dataResponse)
                self.productList = temp
                for x in 0..<temp.count
                {
                    print(temp[x].name)
                }
                DispatchQueue.main.async {
                
                }
            }
            catch let parsingError
            {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUp"
        {
//            super.prepare(for: segue, sender: sender)
            self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)
            segue.destination.modalPresentationStyle = .custom
            segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
        }
        if segue.identifier == "tabBar"
        {
            let vc: mainTabBarController = segue.destination as! mainTabBarController
            vc.productList = productList
        }
    }
    
    func deleteAll()
    {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let batch = NSBatchDeleteRequest(fetchRequest: FavData.fetchRequest())
            _ = try? (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.persistentStoreCoordinator.execute(batch, with: context)
        }
    }
}
