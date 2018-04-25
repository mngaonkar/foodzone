//
//  RestaurantViewController.swift
//  foodzone
//
//  Created by mahadev gaonkar on 24/04/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class RestaurantViewController: UIViewController {

    @IBOutlet weak var chefDataStatus: UILabel!
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var chefExperience: UILabel!
    @IBOutlet weak var cookingCare: UILabel!
    @IBOutlet weak var cookingOil: UILabel!
    @IBOutlet weak var herbs: UILabel!
    @IBOutlet weak var foodID: UILabel!
    
    
    let CHEF_DATA_URL = "http://vmethereumenu.westindia.cloudapp.azure.com:8087"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getChefData(url: CHEF_DATA_URL, parameters: ["ChefName":"Peter"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Get chef entered data from service
    func getChefData(url : String, parameters : [String:String]) {
        let chefEnteredInfo = ChefDataModel()
        var endpoint = url
        endpoint.append("/v1/GetChefInfo")
        print(endpoint)
        print(parameters)
        
        Alamofire.request(endpoint, method: .get, parameters: parameters).responseData {
            response in
            if response.result.isSuccess {
                print("Chef data received")
                let chefData : JSON = JSON(response.result.value!)
                
                if chefData["chef_name"].exists(){
                    chefEnteredInfo.chefName = chefData["chef_name"].string!
                }
                
                if chefData["chef_experience"].exists(){
                    chefEnteredInfo.chefExperience = chefData["chef_experience"].int!
                }
                
                if chefData["cooking_care"].exists(){
                    for item in chefData["cooking_care"].array! {
                        chefEnteredInfo.cookingCare.append(item.string!)
                    }
                }
                
                if chefData["herbs_added"].exists(){
                    for item in chefData["herbs_added"].array! {
                        chefEnteredInfo.herbsAdded.append(item.string!)
                    }
                }
                
                if chefData["cooking_oil"].exists(){
                    chefEnteredInfo.cookingOil = chefData["cooking_oil"].string!
                }
                
                if chefData["lobster_id"].exists(){
                    chefEnteredInfo.foodID = chefData["lobster_id"].int!
                }
                
                self.updateChefData(chefData : chefEnteredInfo)
            }
            else {
                print("Network error = \(response.result.error)")
                self.chefDataStatus.text = "Not able to get chef information"
            }
        }
        
        // Test data
        /*
        let chefData : JSON = JSON(["chef_name": "mahadev",
                                    "chef_experience":16,
                                    "cooking_oil": "Single",
                                    "herbs_added": ["cinnamon"],
                                    "lobster_id": "9004686480",
                                    "cooking_care": ["Low Flame", "Low Spices"]])
        updateChefData(chefData: chefEnteredInfo)
        */
    }
    
    // Update chef data in UI
    func updateChefData(chefData : ChefDataModel) {
        chefName.text = chefData.chefName
        chefExperience.text = "\(chefData.chefExperience) years"
        for item in chefData.cookingCare {
            cookingCare.text?.append(item)
            cookingCare.text?.append(" ")
        }
        
        for item in chefData.herbsAdded {
            herbs.text?.append(item)
            herbs.text?.append(" ")
        }
    
        cookingOil.text = chefData.cookingOil
        foodID.text = String(chefData.foodID)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
