//
//  DialogController.swift
//  vk
//
//  Created by Александр on 13.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit
import RealmSwift

class DialogController: UICollectionViewController {
    let chatRequest = ChatRequest()
    let dialogMethods = DialogMethods()
    
    let realm = RealmMethodsForMessages()
    var messages : List<Message>?
    var token: NotificationToken?
    let buttonItems = ButtonItem()
    var textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField = buttonItems.textField
        textField.delegate = self
        
        let textFieldButton = UIBarButtonItem(customView: textField)
        let sendButton = UIBarButtonItem(image: UIImage(named: "send_message_32"), style: .done, target: self, action: #selector(sendMessage))
        navigationController?.setToolbarHidden(false, animated: false)
        setToolbarItems([textFieldButton, sendButton], animated: false)
        
        chatRequest.loadHistoryOfMessages { [unowned self] in
            self.realm.collectionUpdate(&self.messages, &self.token, self.collectionView!)
        }
        
        collectionView?.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DialogCell", for: indexPath) as! DialogCell
        
        guard let message = messages?[indexPath.row] else { return cell }
        
        cell.message.text = message.text
        if let text = cell.message.text {
            cell.setMessageText(text: text, out: message.out)
        }
        
        let date = dialogMethods.getCellDateText(indexPath, Double(message.date))
        cell.date.text = date
        if let dateOfMessage = cell.date.text {
            cell.setDate(text: dateOfMessage)
        }
        // переворот клетки, не в главном потоке иногда не переворачивается
        DispatchQueue.main.async {
            cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
        }
        
        return cell
    }
}

// MARK: - UICollectionView Delegate FlowLayout

extension DialogController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var sizeOfCell = CGSize(width: 0.0, height: 0.0)
        let message = messages?[indexPath.row]
        if let text = message?.text {
            let height = dialogMethods.getCellHeight(text: text) + 50.0
            sizeOfCell = CGSize(width: UIScreen.main.bounds.width, height: height)
        }
        return sizeOfCell
    }
}

// MARK: - UITextField Delegate

extension DialogController: UITextFieldDelegate {
    @objc func sendMessage() {
        if let textOfMessage = textField.text {
            userDefaults.set(textOfMessage, forKey: "TextOfSendMessage")
            chatRequest.sendMessage()
            textField.text = ""
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
            navigationController?.toolbar.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
            navigationController?.toolbar.frame.origin.y += keyboardSize.height
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
}
