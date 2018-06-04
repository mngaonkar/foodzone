//
//  ServiceEndpoint.swift
//  foodzone
//
//  Created by mahadev gaonkar on 25/04/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class ServiceEndpoint {
    public var endPoint : String
    
    public init() {
        endPoint = "http://vmethereumenu.westindia.cloudapp.azure.com:8081"
    }
    
    public func sendRequest(endpoint : String, requestType : HTTPMethod, param : [String:Any]) {
    }
}

