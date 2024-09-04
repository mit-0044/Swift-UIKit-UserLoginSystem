//
//  HomeViewController.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 02/07/24.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {
          
    let reachability = try! Reachability()
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkConnection()
    }

    @IBAction func hamburgerTapped(_ sender: UIBarButtonItem) {
        let menu = SideMenuNavigationController(rootViewController: SidebarViewController())
        self.present(menu, animated: true, completion: nil)
    }
    
    func getUserDetails(){
        guard let url = URL(string: "http://127.0.0.1:8000/api/user_details") else {
            return
        }
        let userEmail = UserDefaults.standard.string(forKey: "userEmail")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let postString = "email=\(userEmail)"
        urlRequest.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print("error = \(error!)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        
            let json = """
            \(responseString!)
            """
            guard let data = json.data(using: .utf8),
                  let parsedJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                fatalError("Failed to parse JSON")
            }
           
            if  let userID = parsedJSON["id"] as? Int,
                let userRole = parsedJSON["role"] as? String,
                let userName = parsedJSON["name"] as? String,
                let userContact = parsedJSON["contact"] as? String,
                let userAddress = parsedJSON["address"] as? String
            {
                UserDefaults.standard.set(userID, forKey: "userID")
                UserDefaults.standard.set(userRole, forKey: "userRole")
                UserDefaults.standard.set(userName, forKey: "userName")
                UserDefaults.standard.set(userContact, forKey: "userContact")
                UserDefaults.standard.set(userAddress, forKey: "userAddress")
            } else {
                print("Unable to retrieve data from JSON")
            }
        }
        task.resume()
    }
    
    func checkConnection(){
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else if reachability.connection == .cellular {
                print("Reachable via Cellular")
            } else {
                print("Connected via Unknown")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Network not reachable")
            let alert = UIAlertController(title: "No Internet Connection!", message: "Please check your connection adn try again.", preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default) { action in
                do {
                    try self.reachability.startNotifier()
                } catch {
                    print("Unable to start notifier")
                }
            }
            alert.addAction(retryAction)
            self.present(alert, animated: false, completion: nil)
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
