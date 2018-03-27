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
        
        chatRequest.loadDialogsData(completion: {})
        self.realm.tableUpdate(&self.dialogs, &self.token, self.tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return dialogs?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell",
                                                 for: indexPath) as! ChatCell
        guard let dialog = dialogs?[indexPath.row] else { return cell }
        
        if dialog.readState == 0 { cell.backgroundColor = #colorLiteral(red: 0.7570501583, green: 0.7513055267, blue: 1, alpha: 1) } else { cell.backgroundColor = .white }
        
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
  
}
