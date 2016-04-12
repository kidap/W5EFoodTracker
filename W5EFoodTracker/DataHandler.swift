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
    
    var meals = [Meal]()
    var ratingObjects = [PFObject]()
    let group = dispatch_group_create()
    let serialDownloadQueue = dispatch_queue_create("serialDownloadQueue", DISPATCH_QUEUE_SERIAL)
    let serialDownloadQueue2 = dispatch_queue_create("serialDownloadQueue", DISPATCH_QUEUE_SERIAL)
    let concurrentDownloadQueue = dispatch_queue_create("concurrentDownloadQueue", DISPATCH_QUEUE_CONCURRENT)
    
    let queryMeal = PFQuery(className: "Meal")
    let queryRating = PFQuery(className: "Rating")
    print("This is the current user \(PFUser.currentUser()!.objectId!)")
    
    dispatch_group_async(group, serialDownloadQueue) {
      queryRating.whereKey("userID", equalTo: PFUser.currentUser()!.objectId!)
      
      queryRating.findObjectsInBackgroundWithBlock({ (objects, error) in
        if error == nil{
          ratingObjects = objects!
        }
      })
    }
    
    dispatch_group_async(group, serialDownloadQueue) {
      queryMeal.findObjectsInBackgroundWithBlock { (objects, error) in
        if error == nil{
          if let mealObjects = objects where mealObjects.count > 0{
            
            
            for meal in mealObjects{
              print("Looping at all the meal")
              
              dispatch_group_async(group, concurrentDownloadQueue) {
                var image:UIImage? = UIImage()
                
                if let imagePFFile = meal.objectForKey("photo") as? PFFile{
                  dispatch_group_async(group, serialDownloadQueue2) {
                    dispatch_suspend(serialDownloadQueue2)
                    imagePFFile.getDataInBackgroundWithBlock({ (data, error) in
                      if error == nil {
                        image = UIImage(data: data!)
                        dispatch_resume(serialDownloadQueue2)
                      }
                    })
                  }
                }
                dispatch_group_async(group, serialDownloadQueue2) {
                  var rating = 0
                  let filteredRatings = ratingObjects.filter{$0["mealID"] as! String == meal.objectId!}
                  let filteredRating = filteredRatings.first
                  if let rating2 = filteredRating?.valueForKey("rating"){
                    rating = rating2 as! Int
                  }
                  meals.append(Meal(name: meal.valueForKey("name") as! String, photo: image, rating: rating)!)
                  print("This is the meal user \(meal.valueForKey("user")!)")
                }
              }
            }
          }
          
          dispatch_group_notify(group, concurrentDownloadQueue, {
            dispatch_group_notify(group, serialDownloadQueue2, {
              print("Completion block of data retrieval")
              completion(meals: meals)
            })
          })
        }else {
          print(error)
        }
      }
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
    query.whereKey("user", equalTo: PFUser.currentUser()!.objectId!)
    query.whereKey("user", notEqualTo: "")
    var meals = [Meal]()
    //    query.findObjectsInBackgroundWithBlock { (objects, error) in
    //      if let allObjects = objects where allObjects.count > 0{
    //        for object in allObjects{
    //          let image = UIImage()
    //          dispatch_async(dispatch_get_main_queue(), {
    //            meals.append(Meal(name: object.valueForKey("name") as! String, photo: image, rating: object.valueForKey("rating") as! Int)!)
    //            print("This is the current user \(object.valueForKey("user"))")
    //          })
    //        }
    //      }
    //      print(error)
    //    }
    return meals
  }
  func saveMeal(meal:Meal) {
    let predicate = NSPredicate(format: "name == %@", meal.name)
    let query = PFQuery(className: "Meal", predicate: predicate)
    query.findObjectsInBackgroundWithBlock { (objects, error) in
      if let allObjects = objects where allObjects.count > 0{
        if allObjects.first?["user"].string == PFUser.currentUser()?.objectId {
          let image = PFFile(data: UIImageJPEGRepresentation(meal.photo!, 1.0)!)!
          allObjects.first?.setObject(meal.name, forKey: "name")
          allObjects.first?.setObject(image, forKey: "photo")
          allObjects.first?.setObject(meal.rating, forKey: "rating")
          allObjects.first?.setObject(PFUser.currentUser()!.objectId!, forKey: "user")
          allObjects.first?.saveInBackgroundWithBlock({ (status,error) in
            print("Data saved")
          })
        } else{
          let newObject = PFObject(className: "Rating")
          newObject.setObject((allObjects.first?.objectId)!, forKey: "mealID")
          newObject.setObject(meal.rating, forKey: "rating")
          newObject.setObject(PFUser.currentUser()!.objectId!, forKey: "userID")
          newObject.saveInBackgroundWithBlock({ (status, error) in
            print("Data saved")
          })
          //          let predicate = NSPredicate(format: "mealID == %@", allObjects.first?["_id"])
          //          let query = PFQuery(className: "Ratings", predicate: predicate)
          //          query.findObjectsInBackgroundWithBlock { (objects, error) in
          //
          //
          //          let image = PFFile(data: UIImageJPEGRepresentation(meal.photo!, 1.0)!)!
          //          let newObject = PFObject(className: "Meal")
          //          newObject.setObject(meal.name, forKey: "name")
          //          newObject.setObject(image, forKey: "photo")
          //          newObject.setObject(meal.rating, forKey: "rating")
          //          newObject.setObject(PFUser.currentUser()!.objectId!, forKey: "user")
          //          newObject.saveInBackgroundWithBlock({ (status, error) in
          //            print("Data saved")
          //          })
        }
      } else {
        let image = PFFile(data: UIImageJPEGRepresentation(meal.photo!, 1.0)!)!
        let newObject = PFObject(className: "Meal")
        newObject.setObject(meal.name, forKey: "name")
        newObject.setObject(image, forKey: "photo")
        newObject.setObject(meal.rating, forKey: "rating")
        newObject.setObject(PFUser.currentUser()!.objectId!, forKey: "user")
        newObject.saveInBackgroundWithBlock({ (status, error) in
          print("Data saved")
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