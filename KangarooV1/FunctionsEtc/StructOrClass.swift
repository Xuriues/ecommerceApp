//
//  StructOrClass.swift
//  KangarooV1
//
//  Created by Shaun on 24/11/20.
//

import Foundation
import UIKit

class ProductSports: Decodable
{
    var id : String
    var name : String
    var description : String
    var image : String
    var price : Double
}
class Weather: Codable {
    let items: [item]
    let area_metadata : [area_metadata]
}
class item : Codable
{
    let forecasts: [forecast]
}

class  forecast: Codable {
    let area:String
    let forecast:String
}

class area_metadata:Codable
{
    let name:String
    let label_location : label_location
}
class label_location :Codable
{
    let longitude : Double
    let latitude : Double
}
