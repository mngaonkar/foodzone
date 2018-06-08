//
//  RecipeViewController.swift
//  foodzone
//
//  Created by mahadev gaonkar on 03/06/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    var chefEnteredInfo : ChefDataModel!
    @IBOutlet weak var cookingCare: UILabel!
    @IBOutlet weak var cookingOil: UILabel!
    @IBOutlet weak var herbs: UILabel!
    @IBOutlet weak var recipe: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearChefData()
        updateChefData(chefData: chefEnteredInfo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Update chef data in UI
    func updateChefData(chefData : ChefDataModel) {
        
        if chefData.status {
            for item in chefData.cookingCare {
                cookingCare.text?.append(item)
                cookingCare.text?.append(" ")
            }
            
            for item in chefData.herbsAdded {
                herbs.text?.append(item)
                herbs.text?.append(" ")
            }
            
            cookingOil.text = chefData.cookingOil
            recipe.text = chefData.recipeDetail
        }
        else {
            cookingCare.text = "Low Flame"
            cookingOil.text = "Single"
            herbs.text = "Cinnamon"
            recipe.text = "Slow cooked with traditional spices and served with healthy corn soup"
        }

    }

    func clearChefData() {
        self.cookingOil.text = ""
        self.cookingCare.text = ""
        self.herbs.text = ""
        self.recipe.text = ""
    }
}
