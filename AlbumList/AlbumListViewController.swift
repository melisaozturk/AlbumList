//
//  AlbumListViewController.swift
//  AlbumList
//
//  Created by melisa öztürk on 3.04.2019.
//  Copyright © 2019 melisa öztürk. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AlbumListViewController: UIViewController {

    var albumArray = [[String:AnyObject]]()
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activity.isHidden = true

        getData()
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
//        }
    }
    
    
    func getData()
    {
        self.activity.isHidden = false
        self.activity.startAnimating()
        APIClient.sharedInstance.getPost(onSuccess: { json in
//            print(json)
            self.albumArray = json.arrayObject as! [[String:AnyObject]]
            print(self.albumArray)
            DispatchQueue.main.async {
                if self.albumArray.count > 0 {
                    self.collectionView.reloadData()
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                }            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
            self.activity.isHidden = true
            self.activity.stopAnimating()
        })
    }
}

extension AlbumListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        var dict = albumArray[indexPath.row]
        cell.albumTitle.text = dict["title"] as? String
        let imageName = dict["thumbnailUrl"] as? String
        let itemURL = URL(string: imageName!)
    
            APIClient.sharedInstance.getImages(itemURL!, onSuccess: { data in
                DispatchQueue.main.async {
                    print(data)
                    cell.albumImage.contentMode = .scaleAspectFit
                    cell.albumImage.image = UIImage(data: data)
                    print("gösteriliyor ..")
                }
            }, onFailure: { error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.show(alert, sender: nil)
            })
        return cell
    }
}
