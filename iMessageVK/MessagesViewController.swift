//
//  MessagesViewController.swift
//  iMessageVK
//
//  Created by Александр on 28.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet weak var imageOfPost: UIImageView!
    @IBOutlet weak var textOfPost: UILabel!
    
    let defaults = UserDefaults(suiteName: "group.VKGroup")
    
    var news = [String]()
    var newsImages = [String: String]()
    var newsImagesRatio = [String: Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        news = defaults?.array(forKey: "arrayOfNewsText") as! [String]
        newsImages = defaults?.dictionary(forKey: "dictOfImages") as! [String: String]
        newsImagesRatio = defaults?.dictionary(forKey: "dictOfImagesRatio") as! [String: Double]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let layout = MSMessageTemplateLayout()
        let array = news[0].components(separatedBy: "<br>")
        let updateString = array.joined(separator: "\n")
        layout.caption = updateString
        let image = newsImages[news[0]]
        if image != "" {
            let url = URL(string: image!)
            let data = try? Data(contentsOf: url!)
            layout.image = UIImage(data: data!)
        }
        let message = MSMessage()
        message.layout = layout
        activeConversation?.insert(message, completionHandler: nil)
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        
    }
    
    override func didResignActive(with conversation: MSConversation) {

    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {

    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {

    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
 
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {

    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {

    }
    
}
