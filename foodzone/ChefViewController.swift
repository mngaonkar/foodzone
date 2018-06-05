//
//  ChefViewController.swift
//  foodzone
//
//  Created by mahadev gaonkar on 03/06/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class ChefViewController: UIViewController {

    var chefEnteredInfo : ChefDataModel!
    
    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var chefExperience: UILabel!
    @IBOutlet weak var awards: UILabel!
    
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
        chefName.text = chefEnteredInfo.chefName
        chefExperience.text = "\(chefEnteredInfo.chefExperience) Years"
    }
}
