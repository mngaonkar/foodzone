//
//  RestaurantViewController.swift
//  foodzone
//
//  Created by mahadev gaonkar on 25/04/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AVFoundation

class RestaurantViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var chefExperience: UITextField!
    @IBOutlet weak var foodID: UITextField!
    @IBOutlet weak var chefName: UITextField!
    @IBOutlet weak var cookingCare: UITextField!
    @IBOutlet weak var cookingOil: UITextField!
    @IBOutlet weak var herbs: UITextField!
    @IBOutlet weak var foodImage: UIImageView!
    
    
    let experienceData = ["5", "10", "15", "20", "30"]
    let chefNamesData = ["Novok", "Roger", "Peter", "John"]
    let cookingCareData  = ["Low Flame", "High Flame", "Medium Rare", "Well done"]
    let cookingOilData = ["Single", "Multiple"]
    let herbsData = ["Cinnamon", "Red Chillies"]
    var serviceEndPoint : ServiceEndpoint? = nil
    var session : AVCaptureSession!
    var video : AVCaptureVideoPreviewLayer!
    var foodQRCode : String!
    
    @IBAction func submitPressed(_ sender: Any) {
        var endpoint = serviceEndPoint?.endPoint
        var param : [String:Any]
        endpoint?.append("/v1/SetChefInfo")
        param = ["LobsterId": foodID.text!,
                          "ChefName": chefName.text as Any,
                          "ChefExperience": Int(chefExperience.text!) as Any,
                          "HerbsAdded":[herbs.text],
                          "CookingCare": [cookingCare.text],
                          "CookingOil": cookingOil.text as Any]

        Alamofire.request(endpoint!, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
            if response.result.isSuccess {
                print("Data received")
                if response.response?.statusCode == 200 {
                    let _ : JSON = JSON(response.result.value!)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // Do any additional setup after loading the view.
        let experiencePicker = UIPickerView()
        experiencePicker.tag = 1
        experiencePicker.delegate = self
        chefExperience.inputView = experiencePicker
        
        let chefNamePicker = UIPickerView()
        chefNamePicker.tag = 2
        chefNamePicker.delegate = self
        chefName.inputView = chefNamePicker
        
        let cookingCarePicker = UIPickerView()
        cookingCarePicker.tag = 3
        cookingCarePicker.delegate = self
        cookingCare.inputView = cookingCarePicker
        
        let cookingOilPicker = UIPickerView()
        cookingOilPicker.tag = 4
        cookingOilPicker.delegate = self
        cookingOil.inputView = cookingOilPicker
        
        let herbsPicker = UIPickerView()
        herbsPicker.tag = 5
        herbsPicker.delegate = self
        herbs.inputView = herbsPicker
        
        serviceEndPoint = ServiceEndpoint()
        
        //show food image from URL
        Alamofire.request("https://static.independent.co.uk/s3fs-public/thumbnails/image/2009/11/20/23/03lobsteralamy.jpeg").responseImage { response in
            if let picture = response.result.value {
                self.foodImage.image = picture
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitInfo(_ sender: Any) {
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count : Int = 0
        
        switch pickerView.tag {
        case 1:
            count = experienceData.count
        case 2:
            count = chefNamesData.count
        case 3:
            count = cookingCareData.count
        case 4:
            count = cookingOilData.count
        case 5:
            count = herbsData.count
        default:
            count = 0
        }
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            chefExperience.text = experienceData[row]
        case 2:
            chefName.text = chefNamesData[row]
        case 3:
            cookingCare.text = cookingCareData[row]
        case 4:
            cookingOil.text = cookingOilData[row]
        case 5:
            herbs.text = herbsData[row]
        default:
            print("default")
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title : String = ""
        
        switch pickerView.tag {
        case 1:
            title = experienceData[row]
        case 2:
            title = chefNamesData[row]
        case 3:
            title = cookingCareData[row]
        case 4:
            title = cookingOilData[row]
        case 5:
            title = herbsData[row]
        default:
            print("default")
        }
        return title
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
                        self.foodID.text = "\(object.stringValue!)"
                        self.foodQRCode = object.stringValue!
                        self.session?.stopRunning()
                        self.video.removeFromSuperlayer()
                        self.getLobsterImage(lobsterId: self.foodQRCode)
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    func getLobsterImage(lobsterId: String) {
        var endpoint = ServiceEndpoint().endPoint
        var imageURL: String!
        
        // Get lobster image URL
        endpoint.append("/v1/getLobsterImage?lobsterId=\(lobsterId)")

        Alamofire.request(endpoint, method: .get, parameters: nil).responseData {
            response in
            if response.result.isSuccess {
                print("Chef data received")
                let imageData : JSON = JSON(response.result.value!)
                
                if imageData["url"].exists(){
                    imageURL = imageData["url"].string!
                    //imageURL = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Blockchain_Black.jpg/800px-Blockchain_Black.jpg"
                    
                    // Download image from URL and show
                    if imageURL != nil {
                        Alamofire.request(imageURL).responseImage { response in
                            if let picture = response.result.value {
                                self.foodImage.image = picture
                            }
                        }
                    }
                }
                
            } else {
                print("Network error = \(response.result.error)")
            }
        }
    }
}
