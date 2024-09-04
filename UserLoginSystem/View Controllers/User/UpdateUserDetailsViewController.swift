//
//  EditProfileViewController.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 02/08/24.
//

import UIKit

class UpdateUserDetailsViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var contactTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    
    var selectedRowEmail = UserDefaults.standard.string(forKey: "selectedRowEmail")!

    override func viewDidLoad() {
        errorLabel.alpha = 0
        self.getUserDetails()
        super.viewDidLoad()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        self.updateUserDetails()
    }
    
    private func updateUserDetails(){
        let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let contact = contactTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let address = addressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let error = validateFields()
        let contactError = Utilities.isValidContact(contact)
        
        if error != nil {
            showError(error!)
        }else if contactError != true{
            showError("Contact no. contains 10 digits only.")
        }else{
            self.errorLabel.alpha = 0
            guard let url = URL(string: "http://127.0.0.1:8000/api/updateUserDetails") else {
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            let postString = "name=\(name)&email=\(selectedRowEmail)&contact=\(contact)&address=\(address)"
            urlRequest.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    print("error = \(error!)")
                    return
                }
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(responseString!)
                if responseString == "failed" {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error!", message: "Failed to update the details.", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "Okay", style: .default)
                        alert.addAction(okayAction)
                        self.present(alert, animated: false, completion: nil)
                    }
                }else if responseString == "success" {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Success!" as String, message: "Your details are updated successfully.", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "Okay", style: .default){_ in
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                        }
                        alert.addAction(okayAction)
                        self.present(alert, animated: false, completion: nil)
                    }
                }else if responseString == nil {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error!", message: "Something went wrong.", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "Okay", style: .default)
                        alert.addAction(okayAction)
                        self.present(alert, animated: false, completion: nil)
                    }
                }
            }
            task.resume()
        }
    }
    
    func validateFields() -> String? {
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            contactTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "All fields are required."
        }
        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func getUserDetails(){
        guard let url = URL(string: "http://127.0.0.1:8000/api/getUserDetails") else {
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
           
            if  let userType = parsedJSON["type"] as? String,
                let userName = parsedJSON["name"] as? String,
                let userEmail = parsedJSON["email"] as? String,
                let userContact = parsedJSON["contact"] as? String,
                let userAddress = parsedJSON["address"] as? String
            {
                DispatchQueue.main.async {
                    self.nameLabel.text = userName
                    self.typeLabel.text = userType
                    self.emailTextField.text = userEmail
                    self.nameTextField.text = userName
                    self.contactTextField.text = userContact
                    self.addressTextField.text = userAddress
                }
            } else {
                print("Unable to retrieve data from JSON")
            }
        }
        task.resume()
    }
}
