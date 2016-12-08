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
        
        /*let params: [String: Any?] = [
        "contentType" : BPCoordinateRangeMake(41, -72, 20000),
        ]
        Buddy.get("/pictures", parameters: params, class: BPPageResults.self) { (obj: Any, error: Error?) in
         
        if error == nil
        {
            var ids = [Int]()
            var dict = obj as! Dictionary<String, Any>
            var numberOfResults = dict.status
            for var i in obj.status{
            let ids = ids + obj.result.pageResults[i].id
        }
        
        }
        else
        {
            print(error.debugDescription)
        }
        
        }*/

        // Simulated annotations for presentation due to bug
        
        let annotation1 = MKPointAnnotation.init()
        annotation1.coordinate = CLLocationCoordinate2D(latitude: 42.372041,longitude: -71.117420)
        annotation1.title = "Mmh that ice cream was delicious! "
        annotation1.subtitle = "J.P. Licks Inc."
        //annotation.
        Map.addAnnotation(annotation1)
        
        let annotation2 = MKPointAnnotation.init()
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 41.372041,longitude: -71.117420)
        annotation2.title = "#tbt to Freshman year"
        annotation2.subtitle = "Harvard Yard"
        //annotation.
        Map.addAnnotation(annotation2)
        
        let annotation3 = MKPointAnnotation.init()
        annotation3.coordinate = CLLocationCoordinate2D(latitude: 40.372041,longitude: -71.117420)
        annotation3.title = "Where'd all the leavez go?!"
        annotation3.subtitle = "Harvard Yard"
        //annotation.
        Map.addAnnotation(annotation3)
        
        let annotation4 = MKPointAnnotation.init()
        annotation4.coordinate = CLLocationCoordinate2D(latitude: 44.372041,longitude: -71.117420)
        annotation4.title = "This is a road."
        annotation4.subtitle = "Massachussetts Ave."
        //annotation.
        Map.addAnnotation(annotation4)
        
        let annotation5 = MKPointAnnotation.init()
        annotation5.coordinate = CLLocationCoordinate2D(latitude: 49.372041,longitude: -71.117420)
        annotation5.title = "Enter to grow in wisdom."
        annotation5.subtitle = "Depart to serve thy country and thy kind."
        //annotation.
        Map.addAnnotation(annotation5)
        
        let annotation6 = MKPointAnnotation.init()
        annotation6.coordinate = CLLocationCoordinate2D(latitude: 42.372041,longitude: -71.117420)
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
