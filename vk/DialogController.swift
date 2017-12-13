//
//  DialogController.swift
//  vk
//
//  Created by Александр on 13.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit
import RealmSwift

class DialogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  let chatRequest = ChatRequest()
  let dialogMethods = DialogMethods()
  
  let realm = RealmMethodsForMessages()
  var messages : List<Message>?
  var token: NotificationToken?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.hidesBarsOnSwipe = true
    
    chatRequest.loadHistoryOfMessages()
    sleep(1)
    realm.collectionUpdate(&messages, &token, collectionView!)
    
    collectionView?.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var sizeOfCell = CGSize(width: 0.0, height: 0.0)
    let message = messages?[indexPath.row]
    if let text = message?.text {
      let height = dialogMethods.getCellHeight(text: text) + 50.0
      sizeOfCell = CGSize(width: UIScreen.main.bounds.width, height: height)
    }
    return sizeOfCell
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages?.count ?? 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DialogCell", for: indexPath) as! DialogCell
    
    cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
    
    guard let message = messages?[indexPath.row] else { return cell }
    
    cell.message.text = message.text
    if let text = cell.message.text {
      cell.setMessageText(text: text, out: message.out)
    }
    
    let date = dialogMethods.getCellDateText(indexPath, Double(message.date))
    cell.date.text = date
    if let dateOfMessage = cell.date.text {
      cell.setDate(text: dateOfMessage)
    }
    
    return cell
  }
  
  // MARK: UICollectionViewDelegate
  
  /*
   // Uncomment this method to specify if the specified item should be highlighted during tracking
   override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
   return true
   }
   */
  
  /*
   // Uncomment this method to specify if the specified item should be selected
   override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
   return true
   }
   */
  
  /*
   // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
   override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
   
   }
   */
  
}
