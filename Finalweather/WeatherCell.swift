//
//  WeatherCell.swift
//  Finalweather
//
//  Created by Nivedita Nighojkar on 6/29/17.
//  Copyright © 2017 Nivedita Nighojkar. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var degree: UILabel!

    @IBOutlet weak var weImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
