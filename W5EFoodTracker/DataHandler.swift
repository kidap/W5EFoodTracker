//
//  DataHandler.swift
//  W5EFoodTracker
//
//  Created by Karlo Pagtakhan on 04/11/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit
import Parse

class DataHandler{
  
  func getData (completion:(meals:[Meal])->()) {
    let query = PFQuery(className: "Meal")
    var meals = [Meal]()
    query.findObjectsInBackgroundWithBlock { (objects, error) in
      if let allObjects = objects where allObjects.count > 0{
        for object in allObjects{
          print("Found data in Parse")
          if let imagePFFile = object.objectForKey("photo") as? PFFile{
            imagePFFile.getDataInBackgroundWithBlock({ (data, error) in
              if error == nil {
                let image = UIImage(data: data!)
                
                dispatch_async(dispatch_get_main_queue(), {
                  meals.append(Meal(name: object.valueForKey("name") as! String, photo: image, rating: object.valueForKey("rating") as! Int)!)
                  completion(meals: meals)
                })
              }
            })
          } else {
            print("No image found")
            dispatch_async(dispatch_get_main_queue(), {
              meals.append(Meal(name: object.valueForKey("name") as! String, photo: nil, rating: object.valueForKey("rating") as! Int)!)
              completion(meals: meals)
            })
          }
        }
      }
      print(error)
    }
  }
  
  func loadSampleMeals() ->[Meal] {
    var meals = [Meal]()
    
    let photo1 = UIImage(named: "meal1")!
    let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4)!
    
    let photo2 = UIImage(named: "meal2")!
    let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5)!
    
    let photo3 = UIImage(named: "meal3")!
    let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3)!
    
    meals += [meal1, meal2, meal3]
    return meals
  }
  
  func loadMeals() -> [Meal]? {
    let query = PFQuery(className: "Meal")
    var meals = [Meal]()
    query.findObjectsInBackgroundWithBlock { (objects, error) in
      if let allObjects = objects where allObjects.count > 0{
        for object in allObjects{
          //let imagePFFile = object.objectForKey("photo")
          //let image = UIImage(data: (imagePFFile?.data)!)
          let image = UIImage()
          dispatch_async(dispatch_get_main_queue(), {
            meals.append(Meal(name: object.valueForKey("name") as! String, photo: image, rating: object.valueForKey("rating") as! Int)!)
          })
        }
      }
      print(error)
    }
    return meals
    //return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
  }
  func saveMeal(meal:Meal) {
    let predicate = NSPredicate(format: "name == %@", meal.name)
    let query = PFQuery(className: "Meal", predicate: predicate)
    query.findObjectsInBackgroundWithBlock { (objects, error) in
      if let allObjects = objects where allObjects.count > 0{
        let image = PFFile(data: UIImageJPEGRepresentation(meal.photo!, 1.0)!)!
        allObjects.first?.setObject(meal.name, forKey: "name")
        allObjects.first?.setObject(image, forKey: "photo")
        allObjects.first?.setObject(meal.rating, forKey: "rating")
        allObjects.first?.saveInBackground()
      } else {
        let image = PFFile(data: UIImageJPEGRepresentation(meal.photo!, 1.0)!)!
        let newObject = PFObject(className: "Meal")
        newObject.setObject(meal.name, forKey: "name")
        newObject.setObject(image, forKey: "photo")
        newObject.setObject(meal.rating, forKey: "rating")
        newObject.saveInBackgroundWithBlock({ (status, error) in
          print(error)
        })
      }
    }
  }
  func saveMeals(meals:[Meal]) {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
    if !isSuccessfulSave {
      print("Failed to save meals...")
    }
  }
  
}