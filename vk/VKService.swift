//
//  VKService.swift
//  vk
//
//  Created by Александр on 24.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import WebKit
import FirebaseDatabase

let userDefaults = UserDefaults.standard

class VKService: UIViewController {
  
  @IBOutlet weak var webView: WKWebView! {
    didSet{
      webView.navigationDelegate = self
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "oauth.vk.com"
    urlComponents.path = "/authorize"
    urlComponents.queryItems = [
      URLQueryItem(name: "client_id", value: "6195592"),
      URLQueryItem(name: "display", value: "mobile"),
      URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
      URLQueryItem(name: "scope", value: "270342"),
      URLQueryItem(name: "response_type", value: "token"),
      URLQueryItem(name: "v", value: "5.68")
    ]
    
    let request = URLRequest(url: urlComponents.url!)
    //request.httpShouldHandleCookies = false
    webView.load(request)
    
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension VKService: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    
    guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
      decisionHandler(.allow)
      
      return
    }
    
    let params = fragment
      .components(separatedBy: "&")
      .map { $0.components(separatedBy: "=") }
      .reduce([String: String]()) { result, param in
        var dict = result
        let key = param[0]
        let value = param[1]
        dict[key] = value
        return dict
    }
    
    let token = params["access_token"]
    userDefaults.set(token!, forKey: "token")
    let userID = params["user_id"]
    userDefaults.set(userID, forKey: "userID")
    
    performSegue(withIdentifier: "Enter", sender: token)
    
    decisionHandler(.cancel)
  }
  
  @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
  }
  
}

