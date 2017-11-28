//
//  NewsController.swift
//  vk
//
//  Created by Александр on 15.10.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import UserNotifications

class NewsController: UITableViewController {
  let newsRequest = NewsRequest()
  let postRequest = PostRequest()
  let newsMethods = NewsMethods()
  var news = [New]()
  lazy var photoService = PhotoService(container: tableView)
  var gesture = UITapGestureRecognizer()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    newsMethods.addTapGestureRecognizer(gesture: &gesture)
    
    self.newsRequest.loadNewsData() { [weak self] news in
      self?.news = news
      OperationQueue.main.addOperation {
        self?.tableView.reloadData()
      }
    }
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return news.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let new = news[indexPath.row]
    var dictCell = newsMethods.cellType(new)
    
    let cell = tableView.dequeueReusableCell(withIdentifier: dictCell["identifier"] as! String, for: indexPath) as! NewsCell
    
    cell.nameID.text = new.nameID
    cell.textOfPost.text = new.textOfPost
    cell.likes.text = new.items.likes
    cell.comments.text = new.items.comments
    cell.reposts.text = new.items.reposts
    cell.photoID.image = photoService.photo(atIndexpath: indexPath, byUrl: new.photoID)
    cell.photoOfPost.image = photoService.photo(atIndexpath: indexPath, byUrl: dictCell["imageOfPost"] as! String)
    
    cell.setName(text: cell.nameID.text!)
    cell.setPostText(text: cell.textOfPost.text!)
    dictCell["addedHeight"] = dictCell["addedHeight"] as! Double + cell.heightOfTextOfPost + cell.heightOfTitleOfURL
    tableView.rowHeight = CGFloat(ceil((Double(UIScreen.main.bounds.width) * (dictCell["ratio"] as! Double))) + (dictCell["addedHeight"] as! Double))
    
    if dictCell["identifier"] as! String == "NewsCellLinkPost" {
      cell.titleUrl.text = new.linkOfPost.title
      cell.setTitleOfLink(text: cell.titleUrl.text ?? new.linkOfPost.urlOfLink, originY: tableView.rowHeight)
      cell.titleUrl.isUserInteractionEnabled = true
      cell.titleUrl.addGestureRecognizer(gesture)
    }
    
    cell.setSizeImageOfPost(widthOfScreen: UIScreen.main.bounds.width, ratio: dictCell["ratio"] as! Double)
    cell.setLikesCount(text: cell.likes.text!, originY: tableView.rowHeight)
    cell.setCommentsCount(text: cell.comments.text!, originY: tableView.rowHeight)
    cell.setRepostsCount(text: cell.reposts.text!, originY: tableView.rowHeight)
    
    return cell
  }
  
  @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {
    if unwindSegue.identifier == "toNews" {
      let source = unwindSegue.source as! PostController
      let text = source.textOfPost.text
      postRequest.goPost(text: text ?? "")
      userDefaults.set(false, forKey: "pressedMyLocation")
    }
  }
}
