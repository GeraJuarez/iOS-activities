//
//  GeraCell.swift
//  ejemplo2
//
//  Created by gdaalumno on 9/18/19.
//  Copyright © 2019 gdaalumno. All rights reserved.
//

import UIKit

class GeraCell: UITableViewCell {
    
    @IBOutlet weak var imageUI: UIImageView!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var subTitle1: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
