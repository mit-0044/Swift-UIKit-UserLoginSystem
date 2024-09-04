//
//  HomeModel.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 15/07/24.
//

import Foundation

protocol HomeModelProtocol: AnyObject {
    func itemsDownloaded(items: NSArray)
}

class HomeModel: NSObject, URLSessionDataDelegate {
    
    //properties
    weak var delegate: HomeModelProtocol!
    let urlPath = "http://hourofswift.com/service.php" //this will be changed to the path where service.php lives
    func downloadItems() {
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                self.parseJSON(data!)
            }
        }
        task.resume()
    }
    
    
}
