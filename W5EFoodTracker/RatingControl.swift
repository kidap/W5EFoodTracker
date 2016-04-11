//
//  RatingControl.swift
//  W5EFoodTracker
//
//  Created by Karlo Pagtakhan on 04/10/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

class RatingControl: UIView {
  // MARK: Properties
  
  var ratingButtons = [UIButton]()
  let spacing = 5
  let starCount = 5
  var stars = 5
  
  var rating = 0 {
    didSet {
      setNeedsLayout()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    for _ in 0..<starCount {
      
      let filledStarImage = UIImage(named: "filledStar")
      let emptyStarImage = UIImage(named: "emptyStar")
      
      
      let button = UIButton()
      button.setImage(emptyStarImage, forState: .Normal)
      button.setImage(filledStarImage, forState: .Selected)
      button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
      //button.backgroundColor = UIColor.redColor()
      button.adjustsImageWhenHighlighted = false
      
      button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), forControlEvents: .TouchDown)
      ratingButtons += [button]
      
      addSubview(button)
    }
  }
  override func intrinsicContentSize() -> CGSize {
    let buttonSize = Int(frame.size.height)
    let width = (buttonSize * stars) + (spacing * (stars - 1))
    
    return CGSize(width: width, height: buttonSize)
  }
  func ratingButtonTapped(button: UIButton) {
    print("Button pressed 👍")
    rating = ratingButtons.indexOf(button)! + 1
  }
  override func layoutSubviews() {
    // Set the button's width and height to a square the size of the frame's height.
    let buttonSize = Int(frame.size.height)
    var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
    
    // Offset each button's origin by the length of the button plus some spacing.
    for (index, button) in ratingButtons.enumerate() {
      buttonFrame.origin.x = CGFloat(index * (buttonSize + 5))
      button.frame = buttonFrame
    }
    updateButtonSelectionStates()
  }
  
  func updateButtonSelectionStates() {
    for (index, button) in ratingButtons.enumerate() {
      // If the index of a button is less than the rating, that button should be selected.
      button.selected = index < rating
    }
  }
}
