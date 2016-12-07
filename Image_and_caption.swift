//
//  Image_and_caption.swift
//  The Billboard
//
//  Created by Samuel Meijer on 07/12/2016.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import Foundation

// Define a class to store the image and the associated caption. 

class imageAndCaption
{
    // Properties
    var image: Data
    var caption: String?
    
    // Initialisation
    init?(image: Data, caption: String)
    {
        // Error checking
        if image.isEmpty
        {
            return nil
        }
        
        self.image = image
    }
}
