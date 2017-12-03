//
//  NewsRequest.swift
//  vk
//
//  Created by Александр on 15.10.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import Alamofire

class NewsRequest {
  let requestMethods = RequestMethods()
  
  func loadNewsData(completion: @escaping ([New]) -> ()) {
    
    let parameters: Parameters = [
      "access_token": userDefaults.string(forKey: "token") ?? print("no Token"),
      "filters": "post,photo,photo_tag,note",
      "count": "20"
    ]
   
    Alamofire.request(requestMethods.baseURL + requestMethods.newsGet, parameters: parameters).responseJSON(queue: .global()) { response in
      var news = [New]()
      var newsText = [String]()
      var newsImages = [String: String]()
      var newsImagesRatio = [String: Double]()
      let data = response.value as! [String: Any]
      let dict = data["response"] as! [String: Any]
      let arrayItems = dict["items"] as! [Any]
      
      for value in arrayItems {
        let item = value as! [String:Any]
        let sourceID = item["source_id"] as! Int
        let textOfPost = item["text"] as? String ?? ""
        var photoID = ""
        var nameID = ""
        let photoOfPost = PhotoOfPost()
        let linkOfPost = LinkOfPost()
        let items = Item()
        var typeOfAttachment = TypeOfAttachment.none
        if item["attachment"] != nil {
          let attachment = item["attachment"] as! [String:Any]
          let typeOfAttachmentJSON = attachment["type"] as! String
          
          switch typeOfAttachmentJSON {
          case "photo" :
            typeOfAttachment = .photo
            let photoAttachment = attachment["photo"] as! [String:Any]
            photoOfPost.urlOfImage = photoAttachment["src_big"] as! String
            photoOfPost.width = photoAttachment["width"] as! Int
            photoOfPost.height = photoAttachment["height"] as! Int
          case "link" :
            typeOfAttachment = .link
            let linkAttachment = attachment["link"] as! [String:Any]
            linkOfPost.urlOfLink = linkAttachment["url"] as! String
            linkOfPost.title = linkAttachment["title"] as! String
            if linkAttachment["image_big"] != nil {
              linkOfPost.image = (linkAttachment["image_big"] as! String)
            } else if linkAttachment["image_src"] != nil {
              linkOfPost.image = (linkAttachment["image_src"] as! String)
            } else { linkOfPost.image = "" }
          case "video" :
            typeOfAttachment = .video
            let videoAttachment = attachment["video"] as! [String:Any]
            photoOfPost.urlOfImage = videoAttachment["image_big"] as! String
          case "audio" :
            typeOfAttachment = .none
          case "poll":
            typeOfAttachment = .none
          case "doc":
            typeOfAttachment = .none
          default: break
          }
        } else {
          typeOfAttachment = .none
        }
        //FIXME:
        if item["photos"] != nil {
          let arrayOfPhotos = item["photos"] as! [Any]
          let photoDescribe = arrayOfPhotos[1] as! [String: Any]
          photoOfPost.urlOfImage = photoDescribe["src_big"] as! String
          photoOfPost.width = photoDescribe["width"] as! Int
          photoOfPost.height = photoDescribe["height"] as! Int
        }
        
        if item["likes"] != nil {
          let likesDescription = item["likes"] as! [String:Any]
          items.likes = String(likesDescription["count"] as! Int)
        }
        if item["comments"] != nil {
          let commentsDescription = item["comments"] as! [String:Any]
          items.comments = String(commentsDescription["count"] as! Int)
        }
        if item["reposts"] != nil {
          let repostsDescription = item["reposts"] as! [String:Any]
          items.reposts = String(repostsDescription["count"] as! Int)
        }
        if sourceID > 0 {
          let arrayOfProfiles = dict["profiles"] as! [Any]
          for value in arrayOfProfiles {
            let profile = value as! [String:Any]
            if sourceID == profile["uid"] as! Int {
              photoID = profile["photo"] as! String
              nameID = profile["first_name"] as! String + " " + (profile["last_name"] as! String)
            }
          }
        } else {
          let arrayOfGroups = dict["groups"] as! [Any]
          for value in arrayOfGroups {
            let group = value as! [String:Any]
            if -sourceID == group["gid"] as! Int {
              photoID = group["photo"] as! String
              nameID = group["name"] as! String
            }
          }
        }
        news.append(New(photoID: photoID, nameID: nameID, textOfPost: textOfPost, typeOfAttachment: typeOfAttachment, photoOfPost: photoOfPost, linkOfPost: linkOfPost, items: items))
        if textOfPost != "" {
          newsText.append(textOfPost)
          newsImages[textOfPost] = photoOfPost.urlOfImage
          newsImagesRatio[photoOfPost.urlOfImage] = photoOfPost.ratio
        }
        if (linkOfPost.title != "") && (textOfPost == "") {
          newsText.append(linkOfPost.title)
          if linkOfPost.image != "" {
            newsImages[linkOfPost.title] = linkOfPost.image!
            newsImagesRatio[linkOfPost.image!] = 0.5
          }
        }
      }
      completion(news)
      defaults?.set(newsText, forKey: "arrayOfNewsText")
      defaults?.set(newsImages, forKey: "dictOfImages")
      defaults?.set(newsImagesRatio, forKey: "dictOfImagesRatio")
    }
  }
}
