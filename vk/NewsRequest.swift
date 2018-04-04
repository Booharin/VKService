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
    var parser: NewsParserVK?
    
    func loadNewsData(completion: @escaping (ResponseNewsVK) -> ()) {
        
        let parameters: Parameters = [
            "access_token": userDefaults.string(forKey: "token") ?? print("no Token"),
            "filters": "post,photo,photo_tag,note",
            "count": "40",
            "v": requestMethods.apiVersion
        ]
        
        Alamofire.request(requestMethods.baseURL + requestMethods.newsGet, parameters: parameters).responseJSON (queue: .global()) { [weak self] response in
            guard let data = response.data else {
                print("Error: Invalid Response from Request")
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(NewsParserVK.self, from: data)
                self?.parser = result
            } catch {
                print(error)
            }
            if let response = self?.parser?.response {
                completion(response)
            }
            
            var newsTextArray = [String]()
            var newsImagesDict = [String: String]()
            var newsImagesRatioDict = [String: Double]()
            
            self?.parser?.response.items.forEach { item in
                if let text = item.text {
                    newsTextArray.append(text)
                }
                if let text = item.text, let image = item.attachments?[0].photo?.photo_604 {
                    newsImagesDict[text] = image
                    newsImagesRatioDict[image] = item.attachments?[0].photo?.ratio
                }
            }
            
            defaults?.set(newsTextArray, forKey: "arrayOfNewsText")
            defaults?.set(newsImagesDict, forKey: "dictOfImages")
            defaults?.set(newsImagesRatioDict, forKey: "dictOfImagesRatio")
        }
    }
}
