//
//  LogInViewController.swift
//  W5EFoodTracker
//
//  Created by Karlo Pagtakhan on 04/11/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit
import Parse
class LogInViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate{
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var userTypePicker: UIPickerView!
  @IBOutlet weak var signInLogInLabel: UIButton!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var altOptionButton: UIButton!
  @IBOutlet weak var accountTypeLabel: UILabel!
  var alertError = UIAlertController(title: "Error", message: "", preferredStyle: .Alert)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.prepareView()
    self.prepareDelegates()
    self.prepareGestures()
  }
  //MARK: Preparation
  func prepareView(){
    
    self.alertError.addAction(UIAlertAction(title: "Ok", style: .Default,handler:nil))
    self.usernameTextField.delegate = self
    self.passwordTextField.delegate = self
    self.altOptionButton.titleLabel!.text = "Log in"
  }
  
  func prepareDelegates(){
    self.userTypePicker.delegate = self
    self.userTypePicker.dataSource = self
  }
  func prepareGestures(){
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.displayImagePicker))
    //    self.profilePhotoImageView.addGestureRecognizer(tapGesture)
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
    if self.signInLogInLabel.titleLabel?.text == "Sign up"{
      self.signUp()
    } else if self.signInLogInLabel.titleLabel?.text == "Log in"{
      self.logIn()
    }
  }
  
  @IBAction func logInTapped(sender: UIButton) {
    if self.signInLogInLabel.titleLabel?.text == "Sign up"{
      self.signInLogInLabel.titleLabel?.text = "Log in"
      self.questionLabel.text = "New user?"
      self.altOptionButton.titleLabel!.text = "Sign up here"
      self.userTypePicker.hidden = true
      self.accountTypeLabel.hidden = true
    } else if self.signInLogInLabel.titleLabel?.text == "Log in"{
      self.signInLogInLabel.titleLabel?.text = "Sign up"
      self.questionLabel.text = "Already a user?"
      self.altOptionButton.titleLabel!.text = "Log in"
      self.userTypePicker.hidden = false	
      self.accountTypeLabel.hidden = false
    }
  }
  func signUp(){
    guard let username = self.usernameTextField.text where username != "" else{
      self.alertError.message = "Please enter a username"
      self.presentViewController(self.alertError, animated: true, completion: nil)
      return
    }
    guard let password = self.passwordTextField.text where password != "" else{
      self.alertError.message = "Please enter a password"
      self.presentViewController(self.alertError, animated: true, completion: nil)
      return
    }
    
    let newUser = PFUser()
    newUser.username = username
    newUser.password = password
    newUser["userType"] = self.userTypePicker.selectedRowInComponent(0)
    
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    activityIndicatorView.center = self.view.center
    activityIndicatorView.hidesWhenStopped = true
    self.view.addSubview(activityIndicatorView)
    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    activityIndicatorView.startAnimating()
    
    newUser.signUpInBackgroundWithBlock { (status, error) in
      if error == nil{
        
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        activityIndicatorView.stopAnimating()
        
        print("User was created")
        
        //self.performSegueWithIdentifier("showMain", sender: self)
        
      } else{
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        activityIndicatorView.stopAnimating()
        
        print(error)
        
        self.alertError.message = "User was not created"
        self.presentViewController(self.alertError, animated: true, completion: nil)
      }
    }
  }
  
  func logIn(){
    
    guard let username = self.usernameTextField.text where username != "" else{
      self.alertError.message = "Please enter a username"
      self.presentViewController(self.alertError, animated: true, completion: nil)
      return
    }
    guard let password = self.passwordTextField.text where password != "" else{
      self.alertError.message = "Please enter a password"
      self.presentViewController(self.alertError, animated: true, completion: nil)
      return
    }
    
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    activityIndicatorView.center = self.view.center
    activityIndicatorView.hidesWhenStopped = true
    self.view.addSubview(activityIndicatorView)
    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    activityIndicatorView.startAnimating()
    
    
    PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
      if error == nil{
        
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        activityIndicatorView.stopAnimating()
        
        print("User logged in \(username)")
        
        self.performSegueWithIdentifier("showMain", sender: self)
        
      } else{
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        activityIndicatorView.stopAnimating()
        
        print(error)
        
        self.alertError.message = "Cannot log in user \(username)"
        self.presentViewController(self.alertError, animated: true, completion: nil)
      }
    }
  }
  
  
  //MARK: Image Picker delegate
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    //self.profilePhotoImageView.image = image
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
  
    //MARK: TextField delegate/datasource
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
