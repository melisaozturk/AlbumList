//
//  APIClient.swift
//  AlbumList
//
//  Created by melisa öztürk on 3.04.2019.
//  Copyright © 2019 melisa öztürk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireImage

class APIClient: NSObject {

    let baseURL = "https://jsonplaceholder.typicode.com"
    static let sharedInstance = APIClient()
    static let getPostsEndpoint = "/photos/"
    
    func getPost(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURL + APIClient.getPostsEndpoint
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do{
                if(error != nil){
                    onFailure(error!)
                }
                else{
                    let result = try JSON(data: data!)
                    onSuccess(result)
                }
            }
            catch {
                print(error)
            }
           
        })
        task.resume()
    }
    
    func getImages(_ url: URL, onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void) {
        let pictureURL = URL(string: "\(url)")
        
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: pictureURL!) { (data, response, error) in
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        onSuccess(imageData)
                    } else {
                        print("Couldn't get image: Image is nil")
                        onFailure(error!)
                    }
                } else {
                    print("Couldn't get response code for some reason")
                    onFailure(error!)
                }
            }
        }
        
        downloadPicTask.resume()
    }
}
