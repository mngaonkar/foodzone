//
//  ChefDataModel.swift
//  foodzone
//
//  Created by mahadev gaonkar on 24/04/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChefDataModel {
    var chefExperience : Int
    var chefName : String
    var cookingCare : [String]
    var cookingOil : String
    var herbsAdded : [String]
    var foodID : Int
    var message : String
    var status : Bool
    
    init() {
        chefName = ""
        chefExperience = 0
        cookingCare = []
        cookingOil = ""
        herbsAdded = []
        foodID = 0
        message = ""
        status = false
    }
    
    
}
