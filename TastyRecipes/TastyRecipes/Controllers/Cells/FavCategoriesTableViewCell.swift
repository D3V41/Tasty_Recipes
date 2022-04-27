//
//  FavCategoriesTableViewCell.swift
//  TastyRecipes
//
//  Created by Suelen Vicente on 2022-03-27.
//

import UIKit

//Cell for favorite categories table view
class FavCategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var categoryThumbImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
