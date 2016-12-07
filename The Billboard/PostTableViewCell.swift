//
//  PostTableViewCell.swift
//  The Billboard
//
//  Created by Lars Lorch on 12/7/16.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    // Properties
    
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var imagePost: UIImageView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
