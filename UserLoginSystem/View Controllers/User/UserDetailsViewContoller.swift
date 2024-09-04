    //
//  SettingViewController.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 18/07/24.
//

import UIKit
import SideMenu

class UserDetailsViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var roleLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var activateButton: UIButton!
    @IBOutlet var deactivateButton: UIButton!
    
    let selectedRowEmail = UserDefaults.standard.string(forKey: "selectedRowEmail")!
    let userEmail = UserDefaults.standard.string(forKey: "userEmail")!
    
    override func viewDidLoad() {
        self.userDetails()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        super.viewDidLoad()
    }
    
    @objc func loadList(notification: NSNotification){
        viewDidLoad()
    }
    
    @IBAction func activateTapped(_ sender: UIButton) {
        self.updateUserAccountStatus(1)
    }
    
    @IBAction func deactivateTapped(_ sender: UIButton) {
        self.updateUserAccountStatus(0)
    }
    
    func userDetails(){
        guard let url = URL(string: "http://127.0.0.1:8000/api/user_details") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let postString = "email=\(selectedRowEmail)"
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
           
            if  let role = parsedJSON["role"] as? String,
                let name = parsedJSON["name"] as? String,
                let email = parsedJSON["email"] as? String,
                let contact = parsedJSON["contact"] as? String,
                let accountStatus = parsedJSON["account_status"] as? String,
                let address = parsedJSON["address"] as? String
            {
                DispatchQueue.main.async {
                    self.nameLabel.text = name
                    self.emailLabel.text = email
                    self.roleLabel.text = role
                    self.contactLabel.text = contact
                    self.addressLabel.text = address
                    if (self.userEmail == self.selectedRowEmail) || (role == "Admin"){
                        self.activateButton.isHidden = true
                        self.deactivateButton.isHidden = true
                    }else{
                        if accountStatus == "1" {
                            self.activateButton.isHidden = true
                            self.deactivateButton.isHidden = false
                        }else if accountStatus == "0" {
                            self.deactivateButton.isHidden = true
                            self.activateButton.isHidden = false
                        }
                    }
                    
                }
            } else {
                print("Unable to retrieve data from JSON")
            }
        }
        task.resume()
    }
    
    func updateUserAccountStatus(_ status: Int){
        guard let url = URL(string: "http://127.0.0.1:8000/api/update_user_account_status") else {
            return
        }
        let userEmail = selectedRowEmail
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let postString = "email=\(userEmail)&&account_status=\(status)"
        urlRequest.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print("error = \(error!)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        
            if responseString == "activated" {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success!" as String, message: "Account activated.", preferredStyle: .alert)
                    let doneAction = UIAlertAction(title: "Done", style: .default){_ in
                        self.viewDidLoad()
                    }
                    alert.addAction(doneAction)
                    self.present(alert, animated: false, completion: nil)
                }
            }else if responseString == "deactivated" {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success!" as String, message: "Account deactivated.", preferredStyle: .alert)
                    let doneAction = UIAlertAction(title: "Done", style: .default){_ in
                        self.viewDidLoad()
                    }
                    alert.addAction(doneAction)
                    self.present(alert, animated: false, completion: nil)
                }
            }else if responseString == "failed" {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error!", message: "Something went wrong.", preferredStyle: .alert)
                    let closeAction = UIAlertAction(title: "Close", style: .default)
                    alert.addAction(closeAction)
                    self.present(alert, animated: false, completion: nil)
                }
            }else if responseString == "userNotFound" {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error!", message: "User not found.", preferredStyle: .alert)
                    let closeAction = UIAlertAction(title: "Close", style: .default)
                    alert.addAction(closeAction)
                    self.present(alert, animated: false, completion: nil)
                }
            }else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error!", message: responseString! as String, preferredStyle: .alert)
                    let closeAction = UIAlertAction(title: "Close", style: .default)
                    alert.addAction(closeAction)
                    self.present(alert, animated: false, completion: nil)
                }
            }
        }
        task.resume()
    }
}
