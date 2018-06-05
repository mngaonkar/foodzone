//
//  LobsterDataModel.swift
//  foodzone
//
//  Created by mahadev gaonkar on 03/06/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

public class LobsterDataModel {
    public var Consignor : String
    public var workflowId : String
    public var Consignee : String
    public var Catch_Zone : String
    public var Port_Of_Loading : String
    public var Date_of_Departure : String
    public var Port_Of_Discharge : String
    public var Final_Destination : String
    public var `Type` : String
    public var Grade : String
    public var Weight : String
    public var Size : String
    public var Processing_Estd : String
    public var Processing_Date : String
    public var Fishing_Company : String
    public var CATC_ID : String
    
    var message : String
    var status : Bool
    
    public init() {
        Consignor = "Southern United Seafood Australia"
        workflowId =  "WF1"
        Consignee =  "China Arts"
        Catch_Zone = "FAO ZONE 57 Indian Ocean Eastern"
        Port_Of_Loading = "Melbourne"
        Date_of_Departure = "16546546112"
        Port_Of_Discharge = "Shanghai"
        Final_Destination = "Shanghai"
        Type = "Pacific"
        Grade = "G"
        Weight = "2.5 Kg"
        Size = "Image Processing"
        Processing_Estd = "65146516"
        Processing_Date = "6544161646"
        Fishing_Company = "Alaska Crab Fishing"
        CATC_ID = "CN-001"
        
        message = ""
        status = false
    }
    
    
}
