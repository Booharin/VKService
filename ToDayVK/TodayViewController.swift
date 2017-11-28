//
//  TodayViewController.swift
//  ToDayVK
//
//  Created by Александр on 24.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
  @IBOutlet weak var toDayTable: UITableView!
  let defaults = UserDefaults(suiteName: "group.VKGroup")
  let decoder = JSONDecoder()
  var news = [String]()
  var newsImages = [String: String]()
  var newsImagesRatio = [String: Double]()
  var heightOfToDay: CGFloat = 0.0
  
  @IBAction func goToMainApp(_ sender: Any) {
    let url = URL(string: "mainAppUrl://")!
    self.extensionContext?.open(url, completionHandler: { (success) in
      if (!success) {
        print("error: failed to open app from Today Extension")
      }
    })
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    news = defaults?.array(forKey: "arrayOfNewsText") as! [String]
    newsImages = defaults?.dictionary(forKey: "dictOfImages") as! [String: String]
    newsImagesRatio = defaults?.dictionary(forKey: "dictOfImagesRatio") as! [String: Double]
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
    if activeDisplayMode == .compact {
      self.preferredContentSize = maxSize
    } else if activeDisplayMode == .expanded {
      self.preferredContentSize = CGSize(width: maxSize.width, height: heightOfToDay)
    }
  }
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    completionHandler(NCUpdateResult.newData)
  }
}

extension TodayViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    heightOfToDay = CGFloat(news.count * 70)
    return news.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDayCell", for: indexPath) as! ToDayTableViewCell
    cell.widthOfMainScreen = UIScreen.main.bounds.width
    let new = news[indexPath.row]
    cell.toDayText.text = new
    let image = newsImages[new]
    if image != "" {
      let url = URL(string: image!)
      let data = try? Data(contentsOf: url!)
      cell.toDayImage.image = UIImage(data: data!)
    }
    cell.setPostText(text: cell.toDayText.text!)
    if let ratio = newsImagesRatio[image!] {
      cell.setSizeImageOfPost(widthOfScreen: 70, ratio: ratio)
    }
    toDayTable.rowHeight = 70
    return cell
  }
}
