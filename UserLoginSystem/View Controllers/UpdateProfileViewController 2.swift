//
//  EditProfileViewController.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 02/08/24.
//

import UIKit

class UpdateProfileViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var contactTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    
    let userName = UserDefaults.standard.string(forKey: "userName")
    let userType = UserDefaults.standard.string(forKey: "userType")
    let userEmail = UserDefaults.standard.string(forKey: "userEmail")
    let userContact = UserDefaults.standard.string(forKey: "userContact")
    let userAddress = UserDefaults.standard.string(forKey: "userAddress")
    
    override func viewDidLoad() {
        errorLabel.alpha = 0
        nameLabel.text = userName
        typeLabel.text = userType
        nameTextField.text = userName
        emailTextField.text = userEmail
        contactTextField.text = userContact
        addressTextField.text = userAddress
        super.viewDidLoad()
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        self.redirectToProfileVC()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Submit", message: "Are you sure you want to submit?", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: {_ in
            self.updateUserDetails()
        })
        alert.addAction(submitAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: false, completion: nil)
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
            guard let url = URL(string: "http://127.0.0.1:8000/api/update_user") else {
                return
            }
            let email = UserDefaults.standard.string(forKey: "userEmail")!

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            let postString = "name=\(name)&email=\(email)&contact=\(contact)&address=\(address)"
            urlRequest.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    print("error = \(error!)")
                    return
                }
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                if responseString == "failed" {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error!", message: "Failed to update the details.", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "Okay", style: .default)
                        alert.addAction(okayAction)
                        self.present(alert, animated: false, completion: nil)
                    }
                }else if responseString != nil {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Success!" as String, message: "Your details are updated successfully.", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "Okay", style: .default){_ in
                            self.updateUserStandards()
                        }
                        alert.addAction(okayAction)
                        self.present(alert, animated: false, completion: nil)
                    }
                }else {
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
    
    private func updateUserStandards(){
        guard let url = URL(string: "http://127.0.0.1:8000/api/user_details") else {
            return
        }
        
        let email = UserDefaults.standard.string(forKey: "userEmail")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let postString = "email=\(email)"
        urlRequest.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print("error = \(error!)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            if responseString == "failed" {
                print("Failed to update user default standards.")
            }else if responseString != nil {

                let json = """
                    \(responseString!)
                    """
                guard let data = json.data(using: .utf8),
                      let parsedJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    fatalError("Failed to parse JSON")
                }
               
                if  let userName = parsedJSON["name"] as? String,
                    let userContact = parsedJSON["contact"] as? String,
                    let userAddress = parsedJSON["address"] as? String
                {
                    UserDefaults.standard.removeObject(forKey: "userName")
                    UserDefaults.standard.removeObject(forKey: "userContact")
                    UserDefaults.standard.removeObject(forKey: "userAddress")
                    UserDefaults.standard.set(userName, forKey: "userName")
                    UserDefaults.standard.set(userContact, forKey: "userContact")
                    UserDefaults.standard.set(userAddress, forKey: "userAddress")
                         
                    self.redirectToProfileVC()
                    
                } else {
                    print("Unable to retrieve data from JSON")
                }
            }else if responseString == "userNotFound" {
                print("User details not found...")
            }
        }
        task.resume()
    }
    
    func redirectToProfileVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false, completion: nil)
    }
}
