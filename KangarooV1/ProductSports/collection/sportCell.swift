//
//  sportCell.swift
//  KangarooV1
//
//  Created by Shaun on 25/11/20.
//

import UIKit
var imageCacheCC = NSCache<NSString, UIImage>()

class sportCell: UICollectionViewCell {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    private var task: URLSessionDataTask?

    override class func awakeFromNib()
    {

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        img.image = nil
    }
    
    func configure1(url text:String)
    {
        guard let url = URL(string: text) else { return }
        if let image = imageCacheCC.object(forKey: NSString(string :text))
        {
            self.img.image = image
        }
        else
        {
            task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
                do{
                    if let data = data,
                       let image = UIImage(data: data)
                    {
                        imageCacheCC.setObject(image, forKey: NSString(string: text))
                        DispatchQueue.main.async
                        {
                            self.img.image = image
                            print("Added")
                        }
                    }
                }
            }
            task?.resume()
        }
    }
}
