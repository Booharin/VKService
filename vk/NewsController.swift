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

class NewsController: UITableViewController {
  let newsRequest = NewsRequest()
  var news = [New]()
  lazy var photoService = PhotoService(container: tableView)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.newsRequest.loadNewsData() { [weak self] news in
      self?.news = news
      OperationQueue.main.addOperation {
      self?.tableView.reloadData()
      }
    }
    
//    tableView.estimatedRowHeight = 44
//    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
//  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    let new = news[indexPath.row]
//    return CGFloat((Double(UIScreen.main.bounds.width) * new.photoOfPost.ratio) + 120)
//  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return news.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
    let new = news[indexPath.row]

    cell.setName(text: cell.nameID.text!)
    cell.setPostText(text: cell.textOfPost.text!)
    cell.setLikesCount(text: cell.likes.text!)
    cell.setCommentsCount(text: cell.comments.text!)
    cell.setRepostsCount(text: cell.reposts.text!)
    cell.setSizeImageOfPost(widthOfScreen: UIScreen.main.bounds.width, ratio: new.photoOfPost.ratio)
    
    tableView.rowHeight = CGFloat((Double(UIScreen.main.bounds.width) * new.photoOfPost.ratio) + 120)
    
    cell.nameID.text = new.nameID
    cell.textOfPost.text = new.textOfPost
    cell.likes.text = new.items.likes
    cell.comments.text = new.items.comments
    cell.reposts.text = new.items.reposts
    
    cell.photoID.image = photoService.photo(atIndexpath: indexPath, byUrl: new.photoID)
    
    cell.photoOfPost.image = photoService.photo(atIndexpath: indexPath, byUrl: new.photoOfPost.urlOfImage)

    return cell
  }
}
