//
//  MealsTableViewCell.swift
//  TastyRecipes
//
//  Created by Faiyazuddin Mohammed on 3/30/22.
//

import UIKit

//This is a Table view cell that displays the meal in 1 row of MealsTableViewController of the logged in user.
class MealsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Variables created for meal image and label.
    @IBOutlet weak var mealsImageView: UIImageView!
    @IBOutlet weak var mealsTitleLabel: UILabel!
}
