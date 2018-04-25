//
//  ChefDataModel.swift
//  foodzone
//
//  Created by mahadev gaonkar on 24/04/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ChefDataModel {
    public var chefExperience : Int
    public var chefName : String
    public var cookingCare : [String]
    public var cookingOil : String
    public var herbsAdded : [String]
    public var foodID : Int
    var message : String
    var status : Bool
    
    public init() {
        chefName = ""
        chefExperience = 0
        cookingCare = [""]
        cookingOil = ""
        herbsAdded = [""]
        foodID = 0
        message = ""
        status = false
    }
    
    
}
