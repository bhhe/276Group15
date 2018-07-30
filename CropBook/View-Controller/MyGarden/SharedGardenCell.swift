//
//  SharedGardenCell.swift
//  CropBook
//
//  Created by jon on 2018-07-28.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

class SharedGardenCell: UITableViewCell {

    @IBOutlet weak var gardenLabel : UILabel!
    @IBOutlet weak var deleteButton : UIButton!
    @IBOutlet weak var mapButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
