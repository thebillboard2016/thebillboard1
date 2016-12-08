//
//  imageAndCaptionViewController.swift
//  The Billboard
//
//  Created by Samuel Meijer on 07/12/2016.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import UIKit
import BuddySDK
import CoreLocation
import MapKit

class imageAndCaptionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    // Properties
    @IBOutlet var takenImage: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    // Location things
    let locationManager = CLLocationManager()
    var uploadLocation: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        uploadLocation = (manager.location?.coordinate)!
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        theMapIsBroken()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate the loaction things
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Allow the keyboard to be removed by a tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageAndCaptionViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        }
    
    // Allow the keyboard to be removed by a tap
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadAction(_ sender: UIBarButtonItem) {
        if takenImage.image != nil{
            
            // Fetch the users coordinates at time of uploading
            
            // Convert file from UIImage to BP and upload
            let file:BPFile = BPFile()
            file.contentType = "image/jpg"
            file.fileData = UIImageJPEGRepresentation(takenImage.image!, 0.8)
            
            let imageToSend: [String: Any?] = [
                "data" : file,
                "location" : BPCoordinateMake(uploadLocation.latitude, uploadLocation.latitude),
                "caption" : captionTextField.text!,
                "tag" : nil,
                "watermark" : nil,
                "readPermissions" : "app",
                "writePermissions" : nil,
                "title" : nil,
                "useExifData" : nil
                ]
            
            Buddy.post("/pictures", parameters: imageToSend, class: BPPicture.self, callback: { (x:Any?, error:Error?) in
                print(error.debugDescription)
            })
            uploadNotice()
        }
        else{
            uploadNotice()
        }
    }
    
    @IBAction func saveBarButton(_ sender: UIBarButtonItem) {
        if takenImage.image != nil{
            let imageData = UIImageJPEGRepresentation(takenImage.image!, 0.6)
            let compressedImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
            saveNotice()
        }
        else{
            saveNotice()
        }
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
        if takenImage.image != nil{
            let alertController = UIAlertController(title: "Upload", message: "Your image has been uploaded.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present (alertController, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Upload", message: "You must select an image to upload first!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present (alertController, animated: true, completion: nil)
        }
    }
    func saveNotice(){
        if takenImage.image != nil{
            let alertController = UIAlertController(title: "Save", message: "Your image has been Saved.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present (alertController, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Save", message: "You must select an image to save first!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present (alertController, animated: true, completion: nil)
        }
        
    }
    func theMapIsBroken(){
        let alertController = UIAlertController(title: "Location", message: "There is an unknown location service error.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present (alertController, animated: true, completion: nil)
        }
    
    func theUploadFunctionIsBroken(){
        let alertController = UIAlertController(title: "Upload", message: "The upload has failed.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present (alertController, animated: true, completion: nil)
    }
    
}

