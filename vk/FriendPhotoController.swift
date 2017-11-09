//
//  FriendAvatarController.swift
//  vk
//
//  Created by Александр on 21.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import RealmSwift

class FriendPhotoController: UICollectionViewController {

  var photos : List<Photo>?
  var token: NotificationToken?
  let photosRequest = PhotosRequest()
  let realm = RealmMethodsForPhoto()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    realm.collectionUpdate(&photos, &token, collectionView!)
    
    photosRequest.loadPhotosData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos?.count ?? 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Donatello", for: indexPath) as! FriendPhotoCell
    
    guard let photo = photos?[indexPath.row] else { return cell }
    guard let imgURL = URL(string: photo.photo) else { return cell }
//    cell.photo.af_setImage(withURL: imgURL) // хранит в кэше фотки, память течёт
    Alamofire.request(imgURL).responseData(queue: .global()) { (response) in
      let data = UIImage(data: response.data!)
      DispatchQueue.main.async {
      cell.photo.image = data
      }
    }
    return cell
  }
}







