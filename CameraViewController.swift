//
//  CameraViewController.swift
//  The Billboard
//
//  Created by Samuel Meijer on 05/12/2016.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import UIKit
import AVFoundation


class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var cameraView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takebuttonaction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func photolibraryaction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func saveaction(_ sender: UIButton) {
        let takenphoto = UIImageJPEGRepresentation(cameraView.image!, 0.6)
        let compressedtakenphoto = UIImage(data: takenphoto!)
        UIImageWriteToSavedPhotosAlbum(compressedtakenphoto!, nil, nil, nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        cameraView.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    func savedImage(){
        let alertController = UIAlertController(title: "Image Saved", Bundle: "Image Saved", preferredStyle: .alert)
        let
    }

}
