//
//  CategoriesTableViewCell.swift
//  TastyRecipes
//
//  Created by Faiyazuddin Mohammed on 3/30/22.
//

import UIKit

//This is a Table view cell that displays the Category in 1 row of HomeViewController of the logged in user.
class CategoriesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Variables created for Category image, label and its description.
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var categoryDescriptionLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
}
