//
//  FoodViewController.swift
//  foodzone
//
//  Created by mahadev gaonkar on 03/06/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FoodViewController: UIViewController {

    @IBOutlet weak var lobsterDataStatus: UILabel!
    @IBOutlet weak var lobsterType: UILabel!
    @IBOutlet weak var lobsterGrade: UILabel!
    @IBOutlet weak var lobsterWeight: UILabel!
    @IBOutlet weak var lobsterSize: UILabel!
    
    var lobsterID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let serviceEndpoint = ServiceEndpoint()
        getLobsterDetails(url: serviceEndpoint.endPoint, param: ["LobsterId":self.lobsterID])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    func getLobsterDetails(url : String, param : [String: Any]){
        let lobsterInfo = LobsterDataModel()
        var endpoint = url
        endpoint.append("/getLobsterDetails?lobsterId=\(param["LobsterId"] as! String)")
        print("Endpoint = \(endpoint)")
        
        Alamofire.request(endpoint, method: .get, parameters: param).responseData {
            response in
            if response.result.isSuccess {
                print("Lobster info received")
                let lobsterData : JSON = JSON(response.result.value!)
                
                if lobsterData["Catch_Zone"].exists(){
                    lobsterInfo.Catch_Zone = lobsterData["Catch_Zone"].string!
                }
                
                if lobsterData["Port_Of_Loading"].exists(){
                    lobsterInfo.Port_Of_Loading = lobsterData["Port_Of_Loading"].string!
                }
                
                if lobsterData["Type"].exists(){
                    lobsterInfo.Type = lobsterData["Type"].string!
                }

                if lobsterData["Grade"].exists(){
                    lobsterInfo.Grade = lobsterData["Grade"].string!
                }
                
                if lobsterData["Weight"].exists(){
                    lobsterInfo.Weight = lobsterData["Weight"].string!
                }
                
                if lobsterData["Size"].exists(){
                    lobsterInfo.Size = lobsterData["Size"].string!
                }
                
                self.updateLobsterDataUI(lobsterData : lobsterInfo)
            }
            else {
                print("Network error = \(response.result.error)")
                self.lobsterDataStatus.text = "Not able to get lobster information"
            }
            self.updateLobsterDataUI(lobsterData: lobsterInfo)
        }

    }
    
    func updateLobsterDataUI(lobsterData : LobsterDataModel){
        lobsterType.text = lobsterData.Type
        lobsterGrade.text = lobsterData.Grade
        lobsterWeight.text = lobsterData.Weight
        lobsterSize.text = lobsterData.Size
    }

}
