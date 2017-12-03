//
//  MyGroupsController.swift
//  vk
//
//  Created by Александр on 22.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit
import Alamofire
//import FirebaseDatabase
import CloudKit
import RealmSwift

class MyGroupsController: UITableViewController {
  //let fireBase = FireBaseMethods()
  let myCloud = MyCloud()
  let realm = RealmMethodsForGroups()
  var token: NotificationToken?
  var groups : Results<Group>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.hidesBarsOnSwipe = true
    
    realm.tableUpdate(&groups, &token, tableView)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groups?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsCell
    
    guard let group = groups?[indexPath.row] else { return cell }
    
    cell.nameOfMyGroup.text = group.name
    cell.setGroupName(text: cell.nameOfMyGroup.text!)
    
    guard let imgURL = URL(string: group.photo) else { return cell }
    Alamofire.request(imgURL).responseData(queue: .global()) { (response) in
      OperationQueue.main.addOperation {
        cell.photoOfMyGroup.image = UIImage(data: response.data!)
      }
    }
    return cell
  }
  
  @IBAction func addGroup(segue: UIStoryboardSegue) {
    if segue.identifier == "addGroup" {
      let allGroupsController = segue.source as! AllGroupsController
      guard let indexPath = allGroupsController.tableView.indexPathForSelectedRow else { return }
      let group = allGroupsController.groups[indexPath.row]
      //fireBase.saveData(group: group)
      realm.saveGroupData(group)
      myCloud.saveToiCloud(group)
      if let navController = self.navigationController {
        navController.popViewController(animated: true)
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      guard let deletedGroupID = groups?[indexPath.row].groupID else { return }
      //fireBase.deleteData(group: deletedGroup)
      realm.deleteGroupData(deletedGroupID)
      myCloud.deleteFromiCloud(deletedGroupID)
    }
  }
  
}



