//
//  PhotosRequest.swift
//  vk
//
//  Created by Александр on 30.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class PhotosRequest {
    let realm = RealmMethodsForPhoto()
    let reqestMethods = RequestMethods()
    
    func loadPhotosData() {
        
        let parameters: Parameters = [
            "owner_id": userDefaults.string(forKey: "whoIsYourFriend") ?? print("No ID"),
            "album_id": "profile",
            "rev":"1",
            "count": "200",
            "version": reqestMethods.apiVersion
        ]
        
        Alamofire.request(reqestMethods.baseURL + reqestMethods.getPhotos, parameters: parameters).responseJSON(queue: .global()) { response in
            guard let data = response.value else { return }
            let json = JSON(data)
            let photos = json["response"].compactMap { Photo(json: $0.1 ) }
            if userDefaults.string(forKey: "whoIsYourFriend") != "" {
                self.realm.savePhotoData(photos,
                                         userID: userDefaults.string(forKey: "whoIsYourFriend")!)
            }
        }
    }
}
