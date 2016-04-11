//
//  ViewController.swift
//  W5EFoodTracker
//
//  Created by Karlo Pagtakhan on 04/10/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  //MARK: Properties
  @IBOutlet var nameTextField: UITextField!
  @IBOutlet var mealNameLabel: UILabel!
  @IBOutlet var photoImageView: UIImageView!
  @IBOutlet var ratingControl: RatingControl!
  @IBOutlet var saveButton: UIBarButtonItem!
  
  var meal: Meal?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.nameTextField.delegate = self
    if let meal = meal {
      navigationItem.title = meal.name
      nameTextField.text   = meal.name
      photoImageView.image = meal.photo
      ratingControl.rating = meal.rating
    }
    
    checkValidMealName()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: UITextFieldDelegates
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    mealNameLabel.text = textField.text
        saveButton.enabled = false
    checkValidMealName()
    navigationItem.title = textField.text
  }
  
  //MARK: Actions
  @IBAction func setDefaultLabelText(sender: AnyObject) {
//    mealNameLabel.text = "Default Text"
  }
  @IBAction func selectImageFromPhotoLibrary(sender: AnyObject) {
    
    self.nameTextField.resignFirstResponder()
    
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .PhotoLibrary
    imagePickerController.delegate = self
    self.presentViewController(imagePickerController, animated: true, completion: nil)
  }
  @IBAction func cancel(sender: UIBarButtonItem) {
      // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
      let isPresentingInAddMealMode = presentingViewController is UINavigationController
      
      if isPresentingInAddMealMode {
        dismissViewControllerAnimated(true, completion: nil)
      }
      else {
        navigationController!.popViewControllerAnimated(true)
      }
    }
  
  // MARK: UIImagePickerControllerDelegate
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    // Dismiss the picker if the user canceled.
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    self.photoImageView.image = selectedImage
    dismissViewControllerAnimated(true, completion: nil)
    
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if saveButton === sender {
      let name = nameTextField.text ?? ""
      let photo = photoImageView.image
      let rating = ratingControl.rating
      
      meal = Meal(name: name, photo: photo, rating: rating)
    }
  }
  
  func checkValidMealName() {
    // Disable the Save button if the text field is empty.
    let text = nameTextField.text ?? ""
    saveButton.enabled = !text.isEmpty
  }
  
}

