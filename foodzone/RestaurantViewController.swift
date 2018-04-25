//
//  RestaurantViewController.swift
//  foodzone
//
//  Created by mahadev gaonkar on 25/04/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var chefExperience: UITextField!
    @IBOutlet weak var foodID: UITextField!
    @IBOutlet weak var chefName: UITextField!
    @IBOutlet weak var cookingCare: UITextField!
    @IBOutlet weak var cookingOil: UITextField!
    @IBOutlet weak var herbs: UITextField!
    
    
    let experienceData = ["5", "10", "15", "20", "30"]
    let chefNamesData = ["Novok", "Roger", "Peter", "John"]
    let cookingCareData  = ["Low Flame", "High Flame", "Medium Rare", "Well done"]
    let cookingOilData = ["Single", "Multiple"]
    let herbsData = ["Cinnamon", "Red Chillies"]
    var serviceEndPoint : ServiceEndpoint? = nil
    
    @IBAction func submitPressed(_ sender: Any) {
        var endpoint = serviceEndPoint?.endPoint
        var parameters : [String:Any]
        endpoint?.append("/v1/SetChefInfo")
        parameters = ["LobsterId": Int(foodID.text!),
                          "ChefName": chefName.text,
                          "ChefExperience": Int(chefExperience.text!),
                          "HerbsAdded":[herbs.text],
                          "CookingCare": [cookingCare.text],
                          "CookingOil": cookingOil.text]
        let result = serviceEndPoint?.sendRequest(endpoint: endpoint!, requestType: .post, param: parameters)
        print(result)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
