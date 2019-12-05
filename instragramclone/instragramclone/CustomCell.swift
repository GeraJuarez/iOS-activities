//
//  CustomCell.swift
//  instragramclone
//
//  Created by gdaalumno on 10/23/19.
//  Copyright © 2019 gdaalumno. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var placeImg: UIImageView!
    @IBOutlet weak var titleTxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
