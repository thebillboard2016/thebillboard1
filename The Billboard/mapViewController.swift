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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Trying to access the GET query, but commented out to at least make a simluted version of The Billboard possible
        
        
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
        
        
        Buddy.get("/pictures", parameters: params, class: BPPageResults.self) { (obj: Any, error: Error?) in
            
        if error == nil
        {
            // Convert return type to NSMutableDictionary
            let results: BPPageResults = obj as! BPPageResults
            let dict0: NSMutableDictionary = results.pageResults[0] as! NSMutableDictionary
        
            // Get location
            let location0: BPCoordinate = dict0["location"]! as! BPCoordinate
            
            print(dict0.description)
            print(" ")
            
            print("Latitude is: \(location0.lat)")
            print("Longitude is: \(location0.lng)")
            print(" ")
            
   
        }
        else
        {
            print(error.debugDescription)
        }
        }
 
        
        
        // Simulated annotations for presentation due to bug
        
        let annotation1 = MKPointAnnotation.init()
        annotation1.coordinate = CLLocationCoordinate2D(latitude: 42.372970,longitude: -71.117487)
        annotation1.title = "Mmh that ice cream was delicious! "
        annotation1.subtitle = "J.P. Licks Inc."
        //annotation.
        Map.addAnnotation(annotation1)
        
        let annotation2 = MKPointAnnotation.init()
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 42.373117,longitude: -71.117019)
        annotation2.title = "#tbt to Freshman year"
        annotation2.subtitle = "Harvard Yard"
        //annotation.
        Map.addAnnotation(annotation2)
        
        let annotation3 = MKPointAnnotation.init()
        annotation3.coordinate = CLLocationCoordinate2D(latitude: 42.373155,longitude: -71.117051)
        annotation3.title = "Where'd all the leavez go?!"
        annotation3.subtitle = "Harvard Yard"
        //annotation.
        Map.addAnnotation(annotation3)
        
        let annotation4 = MKPointAnnotation.init()
        annotation4.coordinate = CLLocationCoordinate2D(latitude: 42.372661,longitude: -71.116419)
        annotation4.title = "This is a road."
        annotation4.subtitle = "Massachussetts Ave."
        //annotation.
        Map.addAnnotation(annotation4)
        
        let annotation5 = MKPointAnnotation.init()
        annotation5.coordinate = CLLocationCoordinate2D(latitude: 42.372863,longitude: -71.116617)
        annotation5.title = "Enter to grow in wisdom."
        annotation5.subtitle = "Massachussetts Ave."
        //annotation.
        Map.addAnnotation(annotation5)
        
        let annotation6 = MKPointAnnotation.init()
        annotation6.coordinate = CLLocationCoordinate2D(latitude: 42.371785,longitude: -71.116407)
        annotation6.title = "Xmas grinding"
        annotation6.subtitle = "Adams House"
        //annotation.
        Map.addAnnotation(annotation6)
        
        
        
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
