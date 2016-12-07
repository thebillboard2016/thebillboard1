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
    
    @IBAction func uploadAction(_ sender: UIBarButtonItem) {
        // This will be the function that uploads the image and caption to the database.
    }
    

    @IBAction func cameraBarButton(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func photolibraryBarButton(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
 
        self.performSegue(withIdentifier: "PhotoSegue1", sender: self)
    }
}


}
