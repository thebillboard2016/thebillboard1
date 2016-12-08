//
//  ImageTableViewController.swift
//  The Billboard
//
//  Created by Lars Lorch on 12/7/16.
//  Copyright © 2016 The Billboard. All rights reserved.
//

import Foundation
import UIKit
import BuddySDK

class ImageTableViewController: UITableViewController {

    // Properties
    
    var posts = [post]()
    let picture_id = "bvc.BscgHMjbFGJsc"

    
    let queue = DispatchQueue.init(label: "queue")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load sample posts
        loadSamplePost()
        
    }
    
    
    // Functions
    
    func loadSamplePost()
    {
        
        // Static default for testing
        let photo1 = UIImage(named: "default Image")!
        let post2 = post(image: photo1, caption: "This is a post", location: nil)
        self.posts += [post2]
        print(" Before Buddy \(self.posts)")
        
        queue.async {
            
        
        // Dynamic photo
        Buddy.get("/pictures/\(self.picture_id)/file", parameters: nil, class: BPFile.self, callback: { (obj: Any?, error: Error?) in
            
            
            if error == nil
            {
                
                let file: BPFile = obj as! BPFile
                let image: UIImage = UIImage.init(data: file.fileData)!
                
                let post1 = post(image: image, caption: "This should be downloaded", location: (0,0))
                self.posts += [post1]
                
                print(" In Buddy \(self.posts)")
                print("The download was successful")
                
                
            }
            else
            {
                print(error.debugDescription)
                print("The download failed")
            }
        })

        
        print(" After Buddy \(self.posts)")

        
        
        }
    
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PostTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostTableViewCell

        // Fetches the appropriate post for the data source layout.
        let postCell = posts[indexPath.row]

        cell.caption.text = postCell.caption
        cell.imageView?.image = postCell.image
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
