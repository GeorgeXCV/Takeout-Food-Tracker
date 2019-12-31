//
//  AddMealViewController.swift
//  Takeout Food Tracker
//
//  Created by George on 31/12/2019.
//  Copyright © 2019 George. All rights reserved.
//

import UIKit

class AddMealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var mealNameField: UITextField!
    @IBOutlet var companyNameField: UITextField!
    @IBOutlet var priceField: UITextField!
    @IBOutlet var dateTimeField: UITextField!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var ratingControl: RatingControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup afer loading the view.
        // Text Field Delegate (to dismiss Keyboard)
        mealNameField.delegate = self
        companyNameField.delegate = self
        priceField.delegate = self
        dateTimeField.delegate = self
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
