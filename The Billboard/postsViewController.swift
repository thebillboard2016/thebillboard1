//
//  postsViewController.swift
//  The Billboard
//
//  Created by Lars Lorch on 12/8/16.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import UIKit
import BuddySDK

class postsViewController: UIViewController {

    // Properties
    @IBOutlet weak var post1: UIImageView!
    @IBOutlet weak var post2: UIImageView!
    @IBOutlet weak var post3: UIImageView!
    @IBOutlet weak var post4: UIImageView!
    @IBOutlet weak var post5: UIImageView!
    @IBOutlet weak var post6: UIImageView!


    //
    var ids = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load sample posts for simulation since query can't be accessed
        loadPosts()
        
    }
    
    
    // Functions
    
    func loadPosts()
    {
        // These are ID's of our simulated presentations because the GET query for location can't be accessed.
        self.ids += ["bvc.GBcgHFDfPrKsc","bvc.zqcgHCtMPrKsc","bvc.MvtJJspfbsKsc","bvc.pCtJJPFpjsKsc","bvc.CHwjDNpMIsKsc","bvc.MDwDGFqmnsKsc"]


        
        // ----------------  1  ----------------
        // GET
        Buddy.get("/pictures/\(self.ids[0])/file", parameters: nil, class: BPFile.self, callback: { (obj: Any?, error: Error?) in
            if error == nil
            {
                // Read file
                let file: BPFile = obj as! BPFile
                self.post1.image = UIImage.init(data: file.fileData)!
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
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
