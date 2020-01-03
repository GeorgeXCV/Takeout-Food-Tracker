//
//  AddMealViewController.swift
//  Takeout Food Tracker
//
//  Created by George on 31/12/2019.
//  Copyright © 2019 George. All rights reserved.
//

import UIKit
import os.log

class AddMealViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var mealNameField: UITextField!
    @IBOutlet var companyNameField: UITextField!
    @IBOutlet var priceField: UITextField!
    @IBOutlet var dateTimeField: UITextField!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var ratingControl: RatingControl!
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field’s user input through delegate callbacks.
        mealNameField.delegate = self
        companyNameField.delegate = self
        priceField.delegate = self
        dateTimeField.delegate = self
        notesTextView.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.mealName
            mealNameField.text = meal.mealName
            companyNameField.text = meal.companyName
            priceField.text = String(meal.price)
            dateTimeField.text = meal.dateTime
            imageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        notesTextView.text = "Notes"
        notesTextView.textColor = UIColor.lightGray
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    // MARK: UITextFieldDelegate

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          // Hide the keyboard.
          textField.resignFirstResponder()
          return true
        }

       func textFieldDidBeginEditing(_ textField: UITextField) {
          // Disable the Save button while editing.
          saveButton.isEnabled = false
        }
    
       func textFieldDidEndEditing(_ textField: UITextField) {
           updateSaveButtonState()
           navigationItem.title = mealNameField.text
        }
    
    // MARK: UITextViewDelegate
    
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        textView.resignFirstResponder()
//        return true
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextView.textColor == UIColor.lightGray { // If placeholder text is displayed, remove it when field is tapped
            notesTextView.text = ""
            notesTextView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
         if notesTextView.text.isEmpty { // If text view still empty, display placeholder again
                      notesTextView.text = "Notes"
                      notesTextView.textColor = UIColor.lightGray
        }
    }


    //MARK: Private Methods

    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = mealNameField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    // MARK: UIImagePickerControllerDelegate

       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         // Dismiss the picker if the user canceled.
         dismiss(animated: true, completion: nil)
       }

     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

          // The info dictionary may contain multiple representations of the image. You want to use the original.
          guard let selectedImage = info[.originalImage] as? UIImage else {
              fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
          }

          imageView.image = selectedImage

          dismiss(animated: true, completion: nil)
      }
      
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        
              // UIImagePickerController is a view controller that lets a user pick media from their photo library.
              let imagePickerController = UIImagePickerController()

              // Only allow photos to be picked, not taken.
              imagePickerController.sourceType = .photoLibrary

              // Make sure ViewController is notified when the user picks an image.
              imagePickerController.delegate = self

              present(imagePickerController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController

        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }

        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }

        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = mealNameField.text ?? ""
        let companyName = companyNameField.text ?? ""
        let price = Double(priceField.text!) ?? 0.0
        let dateTime = dateTimeField.text ?? ""
        let photo = imageView.image
        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(mealName: name, companyName: companyName, price: price, dateTime: dateTime, photo: photo, rating: rating)
    }
}
