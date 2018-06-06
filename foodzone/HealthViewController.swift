//
//  HealthViewController.swift
//  Alamofire
//
//  Created by mahadev gaonkar on 06/06/18.
//

import UIKit
import SwiftyJSON
import Alamofire

class HealthViewController: UIViewController {

    var containerId: String!
    var healthInfo = HealthDataModel()
    
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var waterTransparency: UILabel!
    @IBOutlet weak var healthStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        temperature.layer.cornerRadius = temperature.frame.width/2
        temperature.layer.masksToBounds = true
        humidity.layer.cornerRadius = humidity.frame.width/2
        humidity.layer.masksToBounds = true
        waterTransparency.layer.cornerRadius = waterTransparency.frame.width/2
        waterTransparency.layer.masksToBounds = true
        
        getHealthData(url: ServiceEndpoint().endPoint, param: ["container_id":self.containerId!])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func getHealthData(url : String, param : [String:Any]){
        var endpoint = url
        endpoint.append("/get_container_data?container_id=\(param["container_id"] as! String)")
        print(endpoint)
        print(param)
        
        Alamofire.request(endpoint, method: .get, parameters: param).responseData {
            response in
            if response.result.isSuccess {
                print("Health data received")
                let healthData : JSON = JSON(response.data!)
                
                if healthData["temperature"].exists(){
                    if let value = healthData["temperature"].int {
                        self.healthInfo.temperature = value
                    }
                }
                
                if healthData["humidity"].exists(){
                    if let value = healthData["humidity"].int {
                        self.healthInfo.humidity = value
                    }
                }
                
                if healthData["water_transparency"].exists(){
                    if let value = healthData["water_transparency"].int{
                        self.healthInfo.waterTransparency = value
                    }
                }
                self.healthStatus.text = "Here is the lobster health data"
                self.updateHealthDataUI(healthInfo: self.healthInfo)
            }
            else {
                self.healthStatus.text = "Error getting health data"
            }
        }
    }
    
    func updateHealthDataUI(healthInfo: HealthDataModel){
        temperature.text = "\(self.healthInfo.temperature)"
        switch self.healthInfo.temperature {
        case 1...15:
            temperature.backgroundColor = UIColor(red: 0, green: 0.6275, blue: 0.2824, alpha: 1.0)
        case 16...25:
            temperature.backgroundColor = UIColor.orange
        case 26...Int.max:
            temperature.backgroundColor = UIColor.red
        default:
            temperature.backgroundColor = UIColor(red: 0, green: 0.6275, blue: 0.2824, alpha: 1.0)
        }
    
        
        humidity.text = "\(self.healthInfo.humidity)"
        switch self.healthInfo.humidity {
        case 1...40:
            humidity.backgroundColor = UIColor.red
        case 41...80:
            humidity.backgroundColor = UIColor.orange
        case 81...100:
            humidity.backgroundColor = UIColor(red: 0, green: 0.6275, blue: 0.2824, alpha: 1.0)
        default:
            humidity.backgroundColor = UIColor(red: 0, green: 0.6275, blue: 0.2824, alpha: 1.0)
        }
        
        waterTransparency.text = "\(self.healthInfo.waterTransparency)"
        humidity.text = "\(self.healthInfo.humidity)"
        switch self.healthInfo.waterTransparency {
        case 1...25:
            waterTransparency.backgroundColor = UIColor.red
        case 26...50:
            waterTransparency.backgroundColor = UIColor.orange
        case 51...100:
            waterTransparency.backgroundColor = UIColor(red: 0, green: 0.6275, blue: 0.2824, alpha: 1.0)
        default:
            waterTransparency.backgroundColor = UIColor(red: 0, green: 0.6275, blue: 0.2824, alpha: 1.0)
        }
    }
}
