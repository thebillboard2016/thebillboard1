//
//  mapViewController.swift
//  The Billboard
//
//  Created by Samuel Meijer on 01/12/2016.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import UIKit
import MapKit



class mapViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet var Map: MKMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
