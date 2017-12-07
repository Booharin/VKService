//
//  InterfaceController.swift
//  myWatch Extension
//
//  Created by Александр on 04.12.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import WatchKit
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
  
  @IBOutlet var table: WKInterfaceTable!
  
  private let session: WCSession = WCSession.default
  static var token : String?
  
  private override init() {
    super.init()
    startSession()
  }
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    if let token = self.token {
      setupSession()
    } else {
      showPopup()
    }
  }
  
  func startSession() {
    session.delegate = self
    session.activate()
  }
  
  var token : String?
  var posts: Root?
  let sessionURL: URLSession = {
    let config = URLSessionConfiguration.default
    return URLSession(configuration: config)
  }()
  lazy var url: URL? = {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.vk.com"
    components.path = "/method/newsfeed.get"
    components.queryItems = [
      URLQueryItem(name: "access_token", value: self.token),
//      URLQueryItem(name: "count", value: "20"),
//      URLQueryItem(name: "filters", value: "post,photo,photo_tag,note")
      URLQueryItem(name: "return_banned", value: "0"),
      URLQueryItem(name: "count", value: "10"),
      URLQueryItem(name: "v", value: "5.69")
    ]
    return components.url
  }()
  
  func showPopup(){
    let action = WKAlertAction(title: "Закрыть", style: .cancel) {}
    presentAlert(withTitle: "Так не честно! Войдите в приложение на телефоне!", message: "", preferredStyle: .actionSheet, actions: [action])
  }
  
  func setupSession() {
    guard let url = url else {
      assertionFailure()
      return
    }
    print(url)
    sessionURL.dataTask(with: url) { [weak self] data, response, error in
      guard let data = data else {
        assertionFailure()
        return
      }
      let decoder = JSONDecoder()
      
      do {
        let result = try decoder.decode(Root.self, from: data)
        self?.posts = result
        self?.updateTable()
      } catch {
        print(error)
      }
      }.resume()
    
  }
  
  func updateTable() {
    table.setNumberOfRows((posts?.response.groups.count)!, withRowType: "NewRow")
    for (index, _) in (posts?.response.groups.enumerated())! {
      let row = table.rowController(at: index) as! NewRow
      row.labelInterface.setText(posts?.response.groups[index].name)
    }
  }
  
//  override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
//    guard let selectedPost = posts?.response.items[rowIndex].attachments[0].photo["photo_604"] else { return }
//    let image = selectedPost
//    if image != "" {
//      let url = URL(string: image)
//      let data = try? Data(contentsOf: url!)
//      pushController(withName: "ImageController", context: UIImage(data: data!))
//    }
//  }
  
  override func willActivate() {
    super.willActivate()
  }
  
  override func didDeactivate() {
    super.didDeactivate()
  }
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
  }
  
  func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
    if let token = userInfo["token"] {
      self.token = token as? String
      setupSession()
    }
  }
}

struct Root : Codable {
  let response: Response
}

struct Response: Codable {
  let items: [Post]
  let groups: [Source]
}

struct Post: Codable {
  let type: String
  let text: String?
  let source_id: Int
  //let attachments: [Attachments]
}

struct Source: Codable {
  let id: Int
  let name: String
  let photo_50 : String
}

//struct Attachments: Codable {
//  let photo: [String: String]
//}

//struct Photo: Codable {
//  let photo_130: String
//}




