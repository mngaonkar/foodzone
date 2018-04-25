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
        endPoint = "http://vmethereumenu.westindia.cloudapp.azure.com:8087"
    }
    
    public func sendRequest(endpoint : String, requestType : HTTPMethod, param : [String:Any]) -> JSON{
        var responseData : JSON = ""
        
        Alamofire.request(endpoint, method: requestType, parameters: param).responseData {
            response in
            if response.result.isSuccess {
                print("response received")
                if response.response?.statusCode == 200 {
                    responseData = JSON(response.result.value!)
                }
                else {
                    
                }
            }
            else {
                
            }
        }
        return responseData
    }
}

