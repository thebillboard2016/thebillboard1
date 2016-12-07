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
        let imageData = UIImageJPEGRepresentation(takenImage.image!, 0.6)
        let compressedImage = UIImage(data: imageData!)
        //UPLOAD
        uploadNotice()
    }
    
    @IBAction func saveBarButton(_ sender: UIBarButtonItem) {
        let imageData = UIImageJPEGRepresentation(takenImage.image!, 0.6)
        let compressedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        saveNotice()
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
        takenImage.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    
    //Notices for uploading and saving the image.
    func uploadNotice(){
        let alertController = UIAlertController(title: "Upload", message: "Your image has been uploaded", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present (alertController, animated: true, completion: nil)
    }
    
    func saveNotice(){
        let alertController = UIAlertController(title: "Save", message: "Your image has been Saved", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present (alertController, animated: true, completion: nil)
    }
    
}

