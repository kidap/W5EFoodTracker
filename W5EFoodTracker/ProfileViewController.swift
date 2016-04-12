//
//  ProfileViewController.swift
//  W5EFoodTracker
//
//  Created by Karlo Pagtakhan on 04/11/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {
  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var pickerView: UIPickerView!
  @IBOutlet var tableView: UITableView!
  var dataHandler = DataHandler()
  
  var meals = [Meal](){
    didSet{
      self.tableView.reloadData();
    }
  }
  
  override func viewDidLoad() {
    self.pickerView.dataSource = self
    self.pickerView.delegate = self
    self.tableView.dataSource = self
    self.tableView.delegate = self
    
    self.usernameLabel.text = PFUser.currentUser()?.username
    dataHandler.getData { (meals) in
      self.meals = meals.filter{$0.rating != 0}
      dispatch_async(dispatch_get_main_queue(), {
        self.tableView.reloadData();
      })
    }
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
  //MARK: Table View delegate/datasource
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return meals.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // Table view cells are reused and should be dequeued using a cell identifier.
    let cellIdentifier = "MealTableViewCell"
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
    
    let meal = meals[indexPath.row]
    cell.nameLabel.text = meal.name
    cell.photoImageView.image = meal.photo
    cell.ratingControl.rating = meal.rating
    
    return cell
  }
}
