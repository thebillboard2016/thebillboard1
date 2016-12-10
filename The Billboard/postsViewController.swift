//
//  postsViewController.swift
//  The Billboard
//
//  Created by Lars Lorch on 12/8/16.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import UIKit
import BuddySDK
import CoreLocation

class postsViewController: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate {

    // Properties
    @IBOutlet weak var post1: UIImageView!
    @IBOutlet weak var post2: UIImageView!
    @IBOutlet weak var post3: UIImageView!
    @IBOutlet weak var post4: UIImageView!
    @IBOutlet weak var post5: UIImageView!
    @IBOutlet weak var post6: UIImageView!

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    

    // Arrays for windows
    var ids = [String]()
    var captions = [String]()
    
    
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
        
        // Load sample posts for simulation since query can't be accessed
        loadPosts()
        
    }
    
    
    // Functions
    
    func loadPosts()
    {

        
        // Search for close posts
        let params: [String: Any?] = [
            "ownerID": nil,
            "contentType":nil,
            "caption": nil,
            "locationRange" : BPCoordinateRangeMake(42.372970, -71.117487, 20000),
            "created": nil,
            "lastModified": nil,
            "sortOrder": nil,
            "pagingToken": nil,
            "title": nil
        ]
        
        
        Buddy.get("/pictures", parameters: params, class: BPPageResults.self) { (back: Any, error: Error?) in
            
            if error == nil
            {
                // Convert return type to NSMutableDictionary
                let results: BPPageResults = back as! BPPageResults
                
                // populate arrays
                for index in 0...5                {
                    let dict: NSMutableDictionary = results.pageResults[index] as! NSMutableDictionary
                    let id = dict["id"]!
                    let cap = dict["caption"]
                    self.ids.append(id as! String)
                    self.captions.append(cap as! String)
                    print(self.ids)
                }

                
                // Set up each window
                // ----------------  1  ----------------
                // GET
                Buddy.get("/pictures/\(self.ids[0])/file", parameters: nil, class: BPFile.self, callback: { (obj: Any?, error: Error?) in
                    if error == nil
                    {
                        // Read file
                        let file: BPFile = obj as! BPFile
                        self.post1.image = UIImage.init(data: file.fileData)!
                        self.label1.text = self.captions[0]
                        print("The download was successful")
                    }
                    else
                    {
                        // Error downloading
                        print(error.debugDescription)
                        print("The download failed")
                    }
                })
                
                // ----------------  2  ----------------
                // GET
                Buddy.get("/pictures/\(self.ids[1])/file", parameters: nil, class: BPFile.self, callback: { (obj: Any?, error: Error?) in
                    if error == nil
                    {
                        // Read file
                        let file: BPFile = obj as! BPFile
                        self.post2.image = UIImage.init(data: file.fileData)!
                        self.label2.text = self.captions[1]
                        print("The download was successful")
                    }
                    else
                    {
                        // Error downloading
                        print(error.debugDescription)
                        print("The download failed")
                    }
                })
                // ----------------  3  ----------------
                // GET
                Buddy.get("/pictures/\(self.ids[2])/file", parameters: nil, class: BPFile.self, callback: { (obj: Any?, error: Error?) in
                    if error == nil
                    {
                        // Read file
                        let file: BPFile = obj as! BPFile
                        self.post3.image = UIImage.init(data: file.fileData)!
                        self.label3.text = self.captions[2]
                        print("The download was successful")
                    }
                    else
                    {
                        // Error downloading
                        print(error.debugDescription)
                        print("The download failed")
                    }
                })
                // ----------------  4  ----------------
                // GET
                Buddy.get("/pictures/\(self.ids[3])/file", parameters: nil, class: BPFile.self, callback: { (obj: Any?, error: Error?) in
                    if error == nil
                    {
                        // Read file
                        let file: BPFile = obj as! BPFile
                        self.post4.image = UIImage.init(data: file.fileData)!
                        self.label4.text = self.captions[3]
                        print("The download was successful")
                    }
                    else
                    {
                        // Error downloading
                        print(error.debugDescription)
                        print("The download failed")
                    }
                })
                // ----------------  5  ----------------
                // GET
                Buddy.get("/pictures/\(self.ids[4])/file", parameters: nil, class: BPFile.self, callback: { (obj: Any?, error: Error?) in
                    if error == nil
                    {
                        // Read file
                        let file: BPFile = obj as! BPFile
                        self.post5.image = UIImage.init(data: file.fileData)!
                        self.label5.text = self.captions[4]
                        print("The download was successful")
                    }
                    else
                    {
                        // Error downloading
                        print(error.debugDescription)
                        print("The download failed")
                    }
                })
                // ----------------  6  ----------------
                // GET
                Buddy.get("/pictures/\(self.ids[5])/file", parameters: nil, class: BPFile.self, callback: { (obj: Any?, error: Error?) in
                    if error == nil
                    {
                        // Read file
                        let file: BPFile = obj as! BPFile
                        self.post6.image = UIImage.init(data: file.fileData)!
                        self.label6.text = self.captions[5]
                        print("The download was successful")
                    }
                    else
                    {
                        // Error downloading
                        print(error.debugDescription)
                        print("The download failed")
                    }
                })


            }
            else
            {
                print(error.debugDescription)
            }
        }
        

        
        
        
 
        
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func theMapIsBroken(){
        let alertController = UIAlertController(title: "Location", message: "There is an unknown location service error.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present (alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
