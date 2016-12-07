//
//  imageAndCaptionViewController.swift
//  The Billboard
//
//  Created by Samuel Meijer on 07/12/2016.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import UIKit

class imageAndCaptionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Properties
    @IBOutlet var takenImage: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hopefully display the image!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        takenImage.image = image
        self.dismiss(animated: true, completion: nil);
        }
    
    @IBAction func uploadAction(_ sender: UIBarButtonItem) {
        // This will be the function that uploads the image and caption to the database.
    }
    
}
