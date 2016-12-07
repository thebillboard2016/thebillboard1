//
//  ScrollViewController.swift
//  The Billboard
//
//  Created by Samuel Meijer on 05/12/2016.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var scrollview: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Instantiate the view controllers within the scroll view.
        let Posts = self.storyboard?.instantiateViewController(withIdentifier: "Posts") as UIViewController!
        self.addChildViewController(Posts!)
        self.scrollview.addSubview((Posts?.view)!)
        Posts?.didMove(toParentViewController: self)
        Posts?.view.frame = scrollview.bounds
        
        let Map = self.storyboard?.instantiateViewController(withIdentifier: "Map") as UIViewController!
        self.addChildViewController(Map!)
        self.scrollview.addSubview((Map?.view)!)
        Map?.didMove(toParentViewController: self)
        Map?.view.frame = scrollview.bounds
        
        var MapFrame: CGRect = Map!.view.frame
        MapFrame.origin.x = self.view.frame.width
        Map?.view.frame = MapFrame
        
        // Make the scroll view the ocrrect size.
        self.scrollview.contentSize = CGSize(width: (self.view.frame.width) * 2,height: (self.view.frame.height))
        self.scrollview.contentOffset = CGPoint(x: (self.view.frame.width) * 1, y: (self.view.frame.height))
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func uploadBarButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}
