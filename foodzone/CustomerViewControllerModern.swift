//
//  CustomerViewControllerModern.swift
//  foodzone
//
//  Created by mahadev gaonkar on 31/05/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import Alamofire

class CustomerViewControllerModern: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var session : AVCaptureSession!
    var video : AVCaptureVideoPreviewLayer!
    @IBOutlet weak var chefDataStatus: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    var foodQRCode : String!
    let chefEnteredInfo = ChefDataModel()
    let lobsterInfo = LobsterDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scanButton.layer.cornerRadius = scanButton.frame.width/2
        scanButton.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func scanClicked(_ sender: Any) {
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func scanPressed(_ sender: UIButton) {
        session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch {
            print("Error in capture device")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video?.frame = view.layer.bounds
        view.layer.addSublayer(video!)
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    let alert = UIAlertController(title: "Food ID", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in UIPasteboard.general.string = object.stringValue
                        self.chefDataStatus.text = "Lobster ID = \(object.stringValue!)"
                        self.foodQRCode = object.stringValue!
                        self.session?.stopRunning()
                        self.video.removeFromSuperlayer()
                        self.getChefData(url: ServiceEndpoint().endPoint, param: ["LobsterId":self.foodQRCode])
                        self.getLobsterDetails(url: ServiceEndpoint().endPoint, param: ["LobsterId":self.foodQRCode])
                        self.getLobsterImage(url: ServiceEndpoint().endPoint, param: ["LobsterId":self.foodQRCode])
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func getLobsterDetails(url : String, param : [String: Any]){
        var endpoint = url
        endpoint.append("/getLobsterDetails?lobsterId=\(param["LobsterId"] as! String)")
        print("Endpoint = \(endpoint)")
        
        Alamofire.request(endpoint, method: .get, parameters: param).responseData {
            response in
            if response.result.isSuccess {
                print("Lobster info received")
                let lobsterData : JSON = JSON(response.result.value!)
                
                if lobsterData["Catch_Zone"].exists(){
                    self.lobsterInfo.Catch_Zone = lobsterData["Catch_Zone"].string!
                }
                
                if lobsterData["Port_Of_Loading"].exists(){
                    self.lobsterInfo.Port_Of_Loading = lobsterData["Port_Of_Loading"].string!
                }
                
                if lobsterData["Type"].exists(){
                    self.lobsterInfo.Type = lobsterData["Type"].string!
                }
                
                if lobsterData["Grade"].exists(){
                    self.lobsterInfo.Grade = lobsterData["Grade"].string!
                }
                
                if lobsterData["Weight"].exists(){
                    self.lobsterInfo.Weight = lobsterData["Weight"].string!
                }
                
                if lobsterData["Size"].exists(){
                    self.lobsterInfo.Size = lobsterData["Size"].string!
                }
                
                if lobsterData["Port_Of_Loading"].exists(){
                    self.lobsterInfo.Port_Of_Loading = lobsterData["Port_Of_Loading"].string!
                }
            }
            else {
                print("Network error = \(response.result.error)")
                self.chefDataStatus.text = "Not able to get lobster information"
            }
        }
    }

    // Get chef entered data from service
    func getChefData(url : String, param : [String:Any]) {
        var endpoint = url
        endpoint.append("/v1/GetChefInfo?LobsterId=\(param["LobsterId"] as! String)")
        print(endpoint)
        print(param)
        
        Alamofire.request(endpoint, method: .get, parameters: param).responseData {
            response in
            if response.result.isSuccess {
                print("Chef data received")
                let chefData : JSON = JSON(response.result.value!)
                
                if chefData["chef_name"].exists(){
                    self.chefEnteredInfo.chefName = chefData["chef_name"].string!
                }
                
                if chefData["chef_experience"].exists(){
                    self.chefEnteredInfo.chefExperience = chefData["chef_experience"].int!
                }
                
                if chefData["cooking_care"].exists(){
                    for item in chefData["cooking_care"].array! {
                        self.chefEnteredInfo.cookingCare.append(item.string!)
                    }
                }
                
                if chefData["herbs_added"].exists(){
                    for item in chefData["herbs_added"].array! {
                        self.chefEnteredInfo.herbsAdded.append(item.string!)
                    }
                }
                
                if chefData["cooking_oil"].exists(){
                    self.chefEnteredInfo.cookingOil = chefData["cooking_oil"].string!
                }
                
                if chefData["lobster_id"].exists(){
                    self.chefEnteredInfo.foodID = chefData["lobster_id"].string!
                }
                
                if chefData["url"].exists(){
                    self.chefEnteredInfo.url = chefData["url"].string!
                }
                
                if chefData["award_details"].exists(){
                    self.chefEnteredInfo.awardDetails = chefData["award_details"].string!
                }
                
                if chefData["recipe_detail"].exists(){
                    self.chefEnteredInfo.recipeDetail = chefData["recipe_detail"].string!
                }
                
                self.chefDataStatus.text = "Recieved chef information"
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
    
    // Get chef entered data from service
    func getLobsterImage(url : String, param : [String:Any]) {
        var endpoint = url
        endpoint.append("/v1/getLobsterImage?lobsterId=\(param["LobsterId"] as! String)")
        print(endpoint)
        print(param)
        
        Alamofire.request(endpoint, method: .get, parameters: param).responseData {
            response in
            if response.result.isSuccess {
                print("Chef data received")
                let imageData : JSON = JSON(response.result.value!)
                
                if imageData["url"].exists(){
                    self.lobsterInfo.Image = imageData["url"].string!
                }
                
            } else {
                print("Network error = \(response.result.error)")
                self.chefDataStatus.text = "Not able to get lobster image information"
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeView" {
            let destination = segue.destination as! RecipeViewController
            destination.chefEnteredInfo = self.chefEnteredInfo
        }else if segue.identifier == "foodView" {
            let destination = segue.destination as! FoodViewController
            destination.lobsterID = self.foodQRCode
            destination.lobsterInfoPassed = self.lobsterInfo
        } else if segue.identifier == "locationView"{
            let destination = segue.destination as! MapViewController
            destination.sourceLocation = self.lobsterInfo.Port_Of_Loading
            destination.destinationLocation = self.lobsterInfo.Final_Destination
            destination.lobsterType = self.lobsterInfo.Type
        } else if segue.identifier == "chefView" {
            let destination = segue.destination as! ChefViewController
            destination.chefEnteredInfo = self.chefEnteredInfo
        }
    }
}
