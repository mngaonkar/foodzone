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
    var foodQRCode : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Get chef entered data from service
    func getChefData(url : String, param : [String:Any]) {
        let chefEnteredInfo = ChefDataModel()
        var endpoint = url
        endpoint.append("/v1/GetChefInfo")
        print(endpoint)
        print(param)
        
        Alamofire.request(endpoint, method: .get, parameters: param).responseData {
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
}
