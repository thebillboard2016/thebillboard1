//
//  Image_and_caption.swift
//  The Billboard
//
//  Created by Samuel Meijer on 07/12/2016.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import Foundation
import UIKit

// Define a class to store the image and the associated caption. 

class post
{
    // Properties
    var image: UIImage
    var caption: String
    var location: (Double, Double)?
    
    // Initialisation
    init(image: UIImage, caption: String, location: (Double, Double)?)
    {
        self.image = image
        self.caption = caption
        self.location = location
    }
}
