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

    lazy var response = ResponseNewsVK(items: [],
                                       groups: [],
                                       profiles: [])
    
    lazy var photoService = PhotoService(container: tableView)
    var gesture = UITapGestureRecognizer()
    var heigthOfCell: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hidesBarsOnSwipe = true
        newsMethods.addTapGestureRecognizer(gesture: &gesture)
        
        self.newsRequest.loadNewsData() { [weak self] response in
            self?.response = response
            OperationQueue.main.addOperation { self?.tableView.reloadData() }
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func doRefresh(refreshControl: UIRefreshControl) {
        self.newsRequest.loadNewsData() { [weak self] response in
            self?.response = response
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
        return response.items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let new = response.items[indexPath.row]
        let heightOfText = newsMethods.setHeightOfText(text: new.text ?? "")
        let dictCell = self.newsMethods.cellType(new, response)
        var heightOfTitleOfURL : CGFloat = 0.0
        
        heigthOfCell = CGFloat(ceil((Double(UIScreen.main.bounds.width) * (dictCell["ratio"] as! Double))) + (dictCell["addedHeight"] as! Double))
        
        if dictCell["identifier"] as! String == "NewsCellLinkPost" {
            heightOfTitleOfURL = newsMethods.setHeightOfText(text: new.attachments?[0].title ?? "")
        }
        heigthOfCell += heightOfText + heightOfTitleOfURL
        
        return heigthOfCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let new = response.items[indexPath.row]
        var dictCell = newsMethods.cellType(new, response)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: dictCell["identifier"] as! String, for: indexPath) as! NewsCell
        if let nameID = dictCell["nameID"] as? String {
            cell.nameID.text = nameID
            cell.setName(text: cell.nameID.text!)
        }
        cell.textOfPost.text = new.text
        cell.likes.text = new.likes.countString
        cell.comments.text = new.comments.countString
        cell.reposts.text = new.reposts.countString
        if let photoID = dictCell["photoID"] as? String {
            cell.photoID.image = photoService.photo(atIndexpath: indexPath, byUrl: photoID)
        }
        
        cell.photoOfPost.image = photoService.photo(atIndexpath: indexPath, byUrl: dictCell["imageOfPost"] as! String)
        
        cell.setPostText(text: cell.textOfPost.text!)
        
        if dictCell["identifier"] as! String == "NewsCellGifPost" {
            loadGif(url: dictCell["imageOfPost"] as! String) { [weak cell] image in
                DispatchQueue.main.async {
                    cell?.photoOfPost.image = image
                }
            }
        }
        
        if dictCell["identifier"] as! String == "NewsCellLinkPost" {
            cell.titleUrl.text = new.attachments?[0].link?.title ?? ""
            if let url = new.attachments?[0].link?.url {
                cell.setTitleOfLink(text: cell.titleUrl.text ?? url, originY: heigthOfCell)
            }
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
