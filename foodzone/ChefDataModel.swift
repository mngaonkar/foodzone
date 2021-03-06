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
    public var foodID : String
    public var url : String
    public var awardDetails : String
    public var recipeDetail : String
    var message : String
    var status : Bool
    
    public init() {
        chefName = ""
        chefExperience = 0
        cookingCare = [""]
        cookingOil = ""
        herbsAdded = [""]
        foodID = ""
        url = ""
        awardDetails = ""
        recipeDetail = ""
        message = ""
        status = false
    }
    
    
}
