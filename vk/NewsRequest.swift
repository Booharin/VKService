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
    var parser: ParserVK?
    
    func loadNewsData(completion: @escaping ([ItemVK]) -> ()) {
        
        let parameters: Parameters = [
            "access_token": userDefaults.string(forKey: "token") ?? print("no Token"),
            "filters": "post,photo,photo_tag,note",
            "count": "40",
            "v": requestMethods.apiVersion
        ]
        
        Alamofire.request(requestMethods.baseURL + requestMethods.newsGet, parameters: parameters).response(queue: .global()) { [weak self] response in
            guard let data = response.data else {
                print("Error: Invalid Response from Request")
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(ParserVK.self, from: data)
                self?.parser = result
            } catch {
                print(error)
            }            
//            var news = [New]()
//            var newsText = [String]()
//            var newsImages = [String: String]()
//            var newsImagesRatio = [String: Double]()
            //let data = response.value as! [String: Any]
            //let dict = data["response"] as! [String: Any]
            //let arrayItems = dict["items"] as! [Any]
            
//            for value in arrayItems {
//                let item = value as! [String:Any]
//                let sourceID = item["source_id"] as! Int
//                let textOfPost = item["text"] as? String ?? ""
//                var photoID = ""
//                var nameID = ""
//                let photoOfPost = PhotoOfPost()
//                let linkOfPost = LinkOfPost()
//                let items = Item()
//                var typeOfAttachment = TypeOfAttachment.none
//                if item["attachments"] != nil {
//                    let arrayOfAttachments = item["attachments"] as! [Any]
//                    arrayOfAttachments.forEach { attachment in
//                        let attachment = attachment as! [String:Any]
//                        let typeOfAttachmentJSON = attachment["type"] as! String
//
//                        switch typeOfAttachmentJSON {
//                        case "photo" :
//                            typeOfAttachment = .photo
//                            let photoAttachment = attachment["photo"] as! [String:Any]
//                            photoOfPost.urlOfImage = photoAttachment["photo_604"] as! String
//                            photoOfPost.width = photoAttachment["width"] as! Int
//                            photoOfPost.height = photoAttachment["height"] as! Int
//                        case "link" :
//                            typeOfAttachment = .link
//                            let linkAttachment = attachment["link"] as! [String:Any]
//                            linkOfPost.urlOfLink = linkAttachment["url"] as! String
//                            linkOfPost.title = linkAttachment["title"] as! String
//                            if let imageOfLink = linkAttachment["photo"] as? [String: Any] {
//                                if let photoLinkImage = imageOfLink["photo_604"] as? String {
//                                    if imageOfLink["width"] as! Int > 200 {
//                                        let photoOfLink = PhotoOfPost()
//                                        photoOfLink.urlOfImage = photoLinkImage
//                                        photoOfLink.width = imageOfLink["width"] as! Int
//                                        photoOfLink.height = imageOfLink["height"] as! Int
//                                        linkOfPost.image = photoOfLink
//                                    }
//                                }
//                            }
//                        case "video" :
//                            typeOfAttachment = .video
//                            let videoAttachment = attachment["video"] as! [String:Any]
//                            if let image = videoAttachment["photo_800"] as? String {
//                                photoOfPost.urlOfImage = image
//                            }
//                        case "audio" :
//                            typeOfAttachment = .none
//                        case "poll":
//                            typeOfAttachment = .none
//                        case "doc":
//                            typeOfAttachment = .doc
//                            let photoAttachment = attachment["doc"] as! [String:Any]
//                            photoOfPost.urlOfImage = photoAttachment["url"] as! String
//                            let dict = photoAttachment["preview"] as! [String:Any]
//                            let dictOfPreview = dict["video"] as! [String:Any]
//                            photoOfPost.width = dictOfPreview["width"] as! Int
//                            photoOfPost.height = dictOfPreview["height"] as! Int
//                        default: break
//                        }
//                    }
//                } else {
//                    typeOfAttachment = .none
//                }
//                //FIXME:
//                if item["photos"] != nil {
//
//                    let dictOfPhotos = item["photos"] as! [String: Any]
//                    let arrayOfPhotos = dictOfPhotos["items"] as! [Any]
//                    arrayOfPhotos.forEach { image in
//                        let image = image as! [String: Any]
//                        if let photo = image["photo_604"] as? String {
//                            photoOfPost.urlOfImage = photo
//                            photoOfPost.width = image["width"] as! Int
//                            photoOfPost.height = image["height"] as! Int
//                        }
//                    }
//                }
//
//                if item["likes"] != nil {
//                    let likesDescription = item["likes"] as! [String:Any]
//                    items.likes = String(likesDescription["count"] as! Int)
//                }
//                if item["comments"] != nil {
//                    let commentsDescription = item["comments"] as! [String:Any]
//                    items.comments = String(commentsDescription["count"] as! Int)
//                }
//                if item["reposts"] != nil {
//                    let repostsDescription = item["reposts"] as! [String:Any]
//                    items.reposts = String(repostsDescription["count"] as! Int)
//                }
//                if sourceID > 0 {
//                    let arrayOfProfiles = dict["profiles"] as! [Any]
//                    for value in arrayOfProfiles {
//                        let profile = value as! [String:Any]
//                        if sourceID == profile["id"] as! Int {
//                            photoID = profile["photo_100"] as! String
//                            nameID = profile["first_name"] as! String
//                                + " " + (profile["last_name"] as! String)
//                        }
//                    }
//                } else {
//                    let arrayOfGroups = dict["groups"] as! [Any]
//                    for value in arrayOfGroups {
//                        let group = value as! [String:Any]
//                        if -sourceID == group["id"] as! Int {
//                            photoID = group["photo_100"] as! String
//                            nameID = group["name"] as! String
//                        }
//                    }
//                }
//                news.append(New(photoID: photoID,
//                                nameID: nameID,
//                                textOfPost: textOfPost,
//                                typeOfAttachment: typeOfAttachment,
//                                photoOfPost: photoOfPost,
//                                linkOfPost: linkOfPost,
//                                items: items))
//                if textOfPost != "" {
//                    newsText.append(textOfPost)
//                    newsImages[textOfPost] = photoOfPost.urlOfImage
//                    newsImagesRatio[photoOfPost.urlOfImage] = photoOfPost.ratio
//                }
//                if (linkOfPost.title != "") && (textOfPost == "") {
//                    newsText.append(linkOfPost.title)
//                    if linkOfPost.image?.urlOfImage != "" {
//                        newsImages[linkOfPost.title] = linkOfPost.image?.urlOfImage
//                        newsImagesRatio[linkOfPost.image!.urlOfImage] = linkOfPost.image?.ratio
//                    }
//                }
//            }
            if let items = self?.parser?.response.items {
                completion(items)
            }
//            defaults?.set(newsText, forKey: "arrayOfNewsText")
//            defaults?.set(newsImages, forKey: "dictOfImages")
//            defaults?.set(newsImagesRatio, forKey: "dictOfImagesRatio")
        }
    }
}
