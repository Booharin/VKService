//
//  AllFriendsController.swift
//  vk
//
//  Created by Александр on 21.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class AllFriendsController: UITableViewController {
  
  let friendRequest = FriendsRequest()
  var friends : Results<Friend>?
  var token: NotificationToken?
  let realm = RealmMethodsForFriends()
  
  let queue: OperationQueue = {
    let queue = OperationQueue()
    queue.qualityOfService = .userInteractive
    return queue
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    realm.tableUpdate(&friends, &token, tableView)
    
    self.friendRequest.loadFriendsData()
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
    return friends?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Donatello", for: indexPath) as! AllFriendsCell
    guard let friend = friends?[indexPath.row] else { return cell }
    cell.friendsName.text = friend.firstName + " " + friend.lastName
    cell.setFriendName(text: cell.friendsName.text!)
    
    let getCacheImage = GetCacheImage(url: friend.photoAvatar)
    let setImageToRow = SetImageToRow(indexPath: indexPath, tableView: tableView)
    setImageToRow.addDependency(getCacheImage)
    queue.addOperation(getCacheImage)
    OperationQueue.main.addOperation(setImageToRow)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let indexPathCurrent = tableView.indexPathForSelectedRow
    if friends != nil {
    let whoIsYourFriend = String(friends![(indexPathCurrent?.row)!].userID)
    userDefaults.set(whoIsYourFriend, forKey: "whoIsYourFriend")
    }
  }
}

