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
    
    var news = [ItemVK]()
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
        let heightOfText = newsMethods.setHeightOfText(text: new.text ?? "")
        let dictCell = self.newsMethods.cellType(new)
        var heightOfTitleOfURL : CGFloat = 0.0
        
        heigthOfCell = CGFloat(ceil((Double(UIScreen.main.bounds.width) * (dictCell["ratio"] as! Double))) + (dictCell["addedHeight"] as! Double))
        
        if dictCell["identifier"] as! String == "NewsCellLinkPost" {
            heightOfTitleOfURL = newsMethods.setHeightOfText(text: new.attachments?[0].title ?? "")
        }
        heigthOfCell += heightOfText + heightOfTitleOfURL
        
        return heigthOfCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let new = news[indexPath.row]
        var dictCell = newsMethods.cellType(new)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: dictCell["identifier"] as! String, for: indexPath) as! NewsCell
        
        //cell.nameID.text = new.nameID
        cell.textOfPost.text = new.text
        cell.likes.text = new.likes.countString
        cell.comments.text = new.comments.countString
        cell.reposts.text = new.reposts.countString
        //cell.photoID.image = photoService.photo(atIndexpath: indexPath, byUrl: new.photoID)
        
        cell.photoOfPost.image = photoService.photo(atIndexpath: indexPath, byUrl: dictCell["imageOfPost"] as! String)
        
        cell.setName(text: cell.nameID.text!)
        cell.setPostText(text: cell.textOfPost.text!)
        
        if dictCell["identifier"] as! String == "NewsCellGifPost" {
            loadGif(url: dictCell["imageOfPost"] as! String) { [weak cell] image in
                DispatchQueue.main.async {
                    cell?.photoOfPost.image = image
                }
            }
        }
        
        if dictCell["identifier"] as! String == "NewsCellLinkPost" {
            cell.titleUrl.text = new.attachments?[0].title ?? ""
            cell.setTitleOfLink(text: cell.titleUrl.text ?? (new.attachments?[0].url)!, originY: heigthOfCell)
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
    
    func loadGif(url: String, completion: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async {
            if let image = UIImage.gif(url: url) {
                completion(image)
            }
        }
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
