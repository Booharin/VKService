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
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return news.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let new = news[indexPath.row]
    var identifier = ""
    var ratio = 0.0
    var imageOfPost = ""
    var addedHeight = 0.0

    switch new.typeOfAttachment {
    case .photo:
      identifier = "NewsCellPhotoPost"
      imageOfPost = new.photoOfPost.urlOfImage
      ratio = new.photoOfPost.ratio
      addedHeight = 150.0
    case .link:
      identifier = "NewsCellLinkPost"
      imageOfPost = new.linkOfPost.image ?? ""
      ratio = 0.5
      addedHeight = 180.0
    default:
      identifier = "NewsCellPhotoPost"
      imageOfPost = ""
      ratio = 0.5
      addedHeight = 150.0
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NewsCell
    tableView.rowHeight = CGFloat(ceil((Double(UIScreen.main.bounds.width) * ratio)) + addedHeight)
    
    cell.nameID.text = new.nameID
    cell.textOfPost.text = new.textOfPost
    cell.likes.text = new.items.likes
    cell.comments.text = new.items.comments
    cell.reposts.text = new.items.reposts
    cell.photoID.image = photoService.photo(atIndexpath: indexPath, byUrl: new.photoID)
    cell.photoOfPost.image = photoService.photo(atIndexpath: indexPath, byUrl: imageOfPost)
    
    if identifier == "NewsCellLinkPost" {
    cell.titleUrl.text = new.linkOfPost.title
    cell.setTitleOfLink(text: cell.titleUrl.text ?? new.linkOfPost.urlOfLink, originY: tableView.rowHeight)
    }
    
    cell.setName(text: cell.nameID.text!)
    cell.setPostText(text: cell.textOfPost.text!)
    cell.setLikesCount(text: cell.likes.text!, originY: tableView.rowHeight)
    cell.setCommentsCount(text: cell.comments.text!, originY: tableView.rowHeight)
    cell.setRepostsCount(text: cell.reposts.text!, originY: tableView.rowHeight)
    cell.setSizeImageOfPost(widthOfScreen: UIScreen.main.bounds.width, ratio: ratio)
    
    return cell
  }
}
