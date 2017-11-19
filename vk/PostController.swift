//
//  PostController.swift
//  vk
//
//  Created by Александр on 15.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit

class PostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @IBOutlet weak var textOfPost: UITextField!
  @IBOutlet var toolBar: UIToolbar!

  let postRequest = PostRequest()
  
  @IBAction func openGallery(_ sender: Any) {
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = .photoLibrary;
      imagePicker.allowsEditing = true
      self.present(imagePicker, animated: true, completion: nil)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textOfPost.inputAccessoryView = toolBar
    textOfPost.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 360)
    textOfPost.returnKeyType = UIReturnKeyType.done
    textOfPost.becomeFirstResponder()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func unwindMap(unwindSegue: UIStoryboardSegue) {
    userDefaults.set(true, forKey: "pressedMyLocation")
  }
}
