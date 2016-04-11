//
//  LogInViewController.swift
//  W5EFoodTracker
//
//  Created by Karlo Pagtakhan on 04/11/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit
import Parse
class LogInViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
  @IBOutlet var usernameTextField: UITextField!
  @IBOutlet var profilePhotoImageView: UIImageView!
  @IBOutlet var userTypePicker: UIPickerView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.prepareView()
    self.prepareDelegates()
    self.prepareGestures()
  }
  //MARK: Preparation
  func prepareView(){
    self.profilePhotoImageView.userInteractionEnabled = true
  }
  func prepareDelegates(){
    self.userTypePicker.delegate = self
    self.userTypePicker.dataSource = self
  }
  func prepareGestures(){
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.displayImagePicker))
    self.profilePhotoImageView.addGestureRecognizer(tapGesture)
    print("gesture added to imageview")
  }
  
  //MARK:Actions
  func displayImagePicker(){
    print("Image tapped")
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .PhotoLibrary
    imagePicker.allowsEditing = true
    
    self.presentViewController(imagePicker, animated: true, completion: nil)
  }

  @IBAction func signUpTapped(sender: AnyObject) {
    var newUser = PFUser()
    newUser.
    
    
    self.performSegueWithIdentifier("showMain", sender: self)
  }
  
  @IBAction func logInTapped(sender: AnyObject) {
    self.performSegueWithIdentifier("showMain", sender: self)
  }
  
  //MARK: Image Picker delegate
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
      self.profilePhotoImageView.image = image
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  //MARK: Picker View delegate/datasource
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 2
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch row {
    case 0:
      return "Food Critic"
    case 1:
      return "Casual Foodie"
    default:
      return nil
    }
  }


}
