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
import SwiftGifOrigin
//import UserNotifications

class NewsController: UITableViewController {
    
    let newsRequest = NewsRequest()
    let postRequest = PostRequest()
    let newsMethods = NewsMethods()
    
    var news = [New]()
    lazy var photoService = PhotoService(container: tableView)
    var gesture = UITapGestureRecognizer()
    var heigthOfCell: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hidesBarsOnSwipe = true
        newsMethods.addTapGestureRecognizer(gesture: &gesture)
        
        self.newsRequest.loadNewsData() { [weak self] news in
            self?.news = news
            OperationQueue.main.addOperation { self?.tableView.reloadData() }
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func doRefresh(refreshControl: UIRefreshControl) {
        self.newsRequest.loadNewsData() { [weak self] news in
            self?.news = news
            OperationQueue.main.addOperation { self?.tableView.reloadData() }
        }
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = .black
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let new = news[indexPath.row]
        let heightOfText = newsMethods.setHeightOfText(text: new.textOfPost)
        let dictCell = self.newsMethods.cellType(new)
        var heightOfTitleOfURL : CGFloat = 0.0
        
        heigthOfCell = CGFloat(ceil((Double(UIScreen.main.bounds.width) * (dictCell["ratio"] as! Double))) + (dictCell["addedHeight"] as! Double))
        
        if dictCell["identifier"] as! String == "NewsCellLinkPost" {
            heightOfTitleOfURL = newsMethods.setHeightOfText(text: new.linkOfPost.title)
        }
        heigthOfCell += heightOfText + heightOfTitleOfURL
        
        return heigthOfCell
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
        
        if dictCell["identifier"] as! String == "NewsCellGifPost" {
            var gif = UIImage()
            DispatchQueue.global().async {
                gif = UIImage.gif(url: dictCell["imageOfPost"] as! String)!
            }
            cell.photoOfPost.image = gif
        }
        
        if dictCell["identifier"] as! String == "NewsCellLinkPost" {
            cell.titleUrl.text = new.linkOfPost.title
            cell.setTitleOfLink(text: cell.titleUrl.text ?? new.linkOfPost.urlOfLink, originY: heigthOfCell)
            cell.titleUrl.isUserInteractionEnabled = true
            cell.titleUrl.addGestureRecognizer(gesture)
        }
        
        cell.setSizeImageOfPost(widthOfScreen: UIScreen.main.bounds.width, ratio: dictCell["ratio"] as! Double)
        cell.setLikesCount(text: cell.likes.text!, originY: heigthOfCell)
        cell.setCommentsCount(text: cell.comments.text!, originY: heigthOfCell)
        cell.setRepostsCount(text: cell.reposts.text!, originY: heigthOfCell)
        
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

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
