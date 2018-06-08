//
//  HealthDataModel.swift
//  foodzone
//
//  Created by mahadev gaonkar on 06/06/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

public class HealthDataModel {
    public var temperature: Int
    public var humidity: Int
    public var ph: Int
    public var waterTransparency: Int
    var status : Bool
    
    public init() {
        temperature = 0
        humidity = 0
        ph = 0
        waterTransparency = 0
        status = false
    }
}
