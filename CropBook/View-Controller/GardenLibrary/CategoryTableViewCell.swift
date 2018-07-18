//
//  CategoryTableViewCell.swift
//  CropBook
//
//  Created by jon on 2018-07-17.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var cropImage: UIImageView!
    @IBOutlet weak var cropLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
