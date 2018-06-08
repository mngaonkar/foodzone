//
//  ChefViewController.swift
//  foodzone
//
//  Created by mahadev gaonkar on 03/06/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ChefViewController: UIViewController {

    var chefEnteredInfo : ChefDataModel!
    
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var chefExperience: UILabel!
    @IBOutlet weak var awards: UILabel!
    @IBOutlet weak var chefImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChefInfo(chefEnteredInfo: self.chefEnteredInfo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateChefInfo(chefEnteredInfo: ChefDataModel){
        if chefEnteredInfo.status {
            chefName.text = chefEnteredInfo.chefName
            chefExperience.text = "\(chefEnteredInfo.chefExperience) Years"
            awards.text = chefEnteredInfo.awardDetails
        }else {
            chefName.text = "Roger"
            chefExperience.text = "10 Years"
            awards.text = "Super Chef 2017"
        }
        
        //show chef image from URL
        Alamofire.request(self.chefEnteredInfo.url).responseImage { response in
            if let picture = response.result.value {
                self.chefImage.image = picture
            }
        }
    }
}
