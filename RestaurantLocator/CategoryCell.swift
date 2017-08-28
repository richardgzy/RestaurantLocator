//
//  CategoryCell.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/8/25.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var editCategoryButton: UIButton!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var restaurantCountLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
