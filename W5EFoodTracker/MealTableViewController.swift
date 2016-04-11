//
//  MealTableViewController.swift
//  W5EFoodTracker
//
//  Created by Karlo Pagtakhan on 04/10/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
  var meals = [Meal]()
  var dataHandler = DataHandler()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Use the edit button item provided by the table view controller.
    navigationItem.leftBarButtonItem = editButtonItem()
    
    dataHandler.getData { (meals) in
      self.meals = meals
      self.tableView.reloadData();
    }
    
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return meals.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // Table view cells are reused and should be dequeued using a cell identifier.
    let cellIdentifier = "MealTableViewCell"
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell

    let meal = meals[indexPath.row]
    cell.nameLabel.text = meal.name
    cell.photoImageView.image = meal.photo
    cell.ratingControl.rating = meal.rating
    
    return cell
  }
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      // Delete the row from the data source
      meals.removeAtIndex(indexPath.row)
      dataHandler.saveMeals(meals)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
  }
  
  @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.sourceViewController as? ViewController, meal = sourceViewController.meal {
      if let selectedIndexPath = tableView.indexPathForSelectedRow {
        // Update an existing meal.
        meals[selectedIndexPath.row] = meal
        tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
        dataHandler.saveMeal(meal)
      }
      else {
        // Add a new meal.
        let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
        meals.append(meal)
        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        dataHandler.saveMeal(meal)
      }
      // Save the meals.
      dataHandler.saveMeals(meals)
    }
  }
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowDetail" {
      let mealDetailViewController = segue.destinationViewController as! ViewController
        if let selectedMealCell = sender as? MealTableViewCell {
        let indexPath = tableView.indexPathForCell(selectedMealCell)!
        let selectedMeal = meals[indexPath.row]
        mealDetailViewController.meal = selectedMeal
      }
    }
    else if segue.identifier == "AddItem" {
      print("Adding new meal.")
    }
  }



}
