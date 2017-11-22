//
//  ChatController.swift
//  vk
//
//  Created by Александр on 12.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit
import RealmSwift

class ChatController: UITableViewController {
  let chatRequest = ChatRequest()
  let chatMethods = ChatMethods()
  let realm = RealmMethodsForDialogs()
  var dialogs : Results<Dialog>?
  var token: NotificationToken?
  lazy var photoService = PhotoService(container: tableView)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    realm.tableUpdate(&dialogs, &token, tableView)
    chatRequest.loadDialogsData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dialogs?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
    guard let dialog = dialogs?[indexPath.row] else { return cell }
    cell.photoID.image = photoService.photo(atIndexpath: indexPath, byUrl: dialog.photoID)
    cell.nameID.text = dialog.nameID
    cell.lastMessage.text = dialog.textLastMessage
    let date = chatMethods.getCellDateText(indexPath, Double(dialog.date))
    cell.date.text = date
    
    cell.setLastMessage(text: &cell.lastMessage.text!)
    cell.setDate(text: date, width: UIScreen.main.bounds.width)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let indexPathCurrent = tableView.indexPathForSelectedRow
    let whatDialogID = dialogs?[(indexPathCurrent?.row)!].id
    userDefaults.set(whatDialogID, forKey: "whatDialogID")
  }

  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }    
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
