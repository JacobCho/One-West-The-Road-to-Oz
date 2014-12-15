//
//  NavDrawerViewController.swift
//  
//
//  Created by Jacob Cho on 2014-12-01.
//
//

import UIKit
import Parse

class NavDrawerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let currentUser = User.currentUser()
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var navArray : Array<String> = ["Workouts", "Information", "TT Results", "Settings"]
    var iconArray :Array<UIImage>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileImage()
        setupIcons()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if currentUser.profileImage != nil {
            profileImageView.file = currentUser.profileImage!
            profileImageView.loadInBackground(nil)
        }
    }
    
    func setupProfileImage() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/4
        self.profileImageView.clipsToBounds = true
    }
    
    func setupIcons() {
        
        var workoutIcon : UIImage = UIImage(named: "WorkoutIcon")!
        var infoIcon : UIImage = UIImage(named: "InfoIcon")!
        var TTIcon : UIImage = UIImage(named: "TTIcon")!
        var settingsIcon : UIImage = UIImage(named: "SettingsIcon")!
        iconArray = [workoutIcon, infoIcon, TTIcon, settingsIcon]
        
    }
    
    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return navArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : NavDrawerTableCell = tableView.dequeueReusableCellWithIdentifier("navDrawerCell", forIndexPath: indexPath) as NavDrawerTableCell
        
        let navItem = navArray[indexPath.row]
        let icon = iconArray![indexPath.row]
        cell.navLabel.text = navItem
        cell.iconImageView.image = icon
        
        return cell

    }
    
    // Mark: Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // Mark: Photo picker methods
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch: AnyObject? = touches.anyObject()
        
        if (touch!.view == self.profileImageView) {
            profileImagePressed()
        }
    }
    
    func profileImagePressed() {
        let photoPickerActionSheet: UIAlertController = UIAlertController(title: "Change Profile Image", message: "Choose a new profile image", preferredStyle: .ActionSheet)
        // UIAlertActions
        let photoAction = UIAlertAction(title: "Take New Photo", style: .Default) { (action: UIAlertAction!) -> Void in
            let photoPicker: UIImagePickerController = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .Camera
            photoPicker.allowsEditing = true
            self.presentViewController(photoPicker, animated: true, completion: nil)
        }
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .Default) { (action: UIAlertAction!) -> Void in
            let libraryPicker: UIImagePickerController = UIImagePickerController()
            libraryPicker.delegate = self
            libraryPicker.sourceType = .SavedPhotosAlbum
            self.presentViewController(libraryPicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        // add to AlertController
        photoPickerActionSheet.addAction(photoAction)
        photoPickerActionSheet.addAction(photoLibraryAction)
        photoPickerActionSheet.addAction(cancelAction)
        self.presentViewController(photoPickerActionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        profileImageView.image = image
        let imageFile = PFFile(data: UIImageJPEGRepresentation(image, 0.5))
        currentUser.profileImage = imageFile
        currentUser.saveInBackgroundWithTarget(nil, selector: nil)
    }
}
