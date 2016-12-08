//
//  mapViewController.swift
//  The Billboard
//
//  Created by Samuel Meijer on 01/12/2016.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import UIKit
import MapKit
import BuddySDK



class mapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet var Map: MKMapView!
    var defaultIm: UIImage = UIImage(named: "default Image")!
    var post1 = post(image: #imageLiteral(resourceName: "default Image"), caption: "", location: nil)
    
    
    //var ids = ["bvc.mlnBLLJxLNJsc","bvc.cpnBLwnJLNJsc","bvc.DtbwNFvNLNJsc","bvc.KknBLFJgMNJsc","bvc.tJnBLNxmMNJsc","bvc.HmnBLMNCMNJsc"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // annotations
        /*Buddy.get("/pictures/\(self.ids[0])/file", parameters: nil, class: BPFile.self, callback: { (obj: Any?, error: Error?) in
            if error == nil
            {
                // Read file
                let file: BPFile = obj as! BPFile
                self.annotation1.image = UIImage.init(data: file.fileData)!
                print("The download was successful")
            }
            else
            {
                // Error downloading
                print(error.debugDescription)
                print("The download failed")
            }
        })
    */
        
        
        let annotation1 = MKPointAnnotation.init()
        annotation1.coordinate = CLLocationCoordinate2D(latitude: 42.372041,longitude: -71.117420)
        annotation1.title = "test annotation"
        annotation1.subtitle = "Testtesttest"
        //annotation.
        Map.addAnnotation(annotation1)
        
        
        /*let params: [String: Any?] = [
            "contentType" : BPCoordinateRangeMake(41, -72, 20000),
        ]
        Buddy.get("/pictures", parameters: params, class: BPPageResults.self) { (obj: Any, error: Error?) in
            
            if error == nil
            {
                // var ids = [Int]()
                // var dict = obj as! Dictionary<String, Any>
                // var numberOfResults = dict.status
                //for var i in obj.status{
                    //let ids = ids + obj.result.pageResults[i].id
                //}
                // print(numberOfResults)
                
                print(obj)
            }
            else
            {
                print(error.debugDescription)
            }

        }*/

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Provides error information to the user
    func theMapIsBroken(){
        let alertController = UIAlertController(title: "Map", message: "There is an unknown map error.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present (alertController, animated: true, completion: nil)
    }
}
