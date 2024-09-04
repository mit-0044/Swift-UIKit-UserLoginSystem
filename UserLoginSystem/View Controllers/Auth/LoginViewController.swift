//
//  LoginViewController.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 02/07/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    struct DataResponse: Codable {
        let userID: String
        let name: String
        let email: String
    }
    
    var userID: String = ""
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        UserDefaults.standard.set(nil, forKey: "isUserLoggedIn")
        errorLabel.alpha = 0
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let error = validateFields()
        let emailError = Utilities.isValidEmail(email)
        let passwordError = Utilities.isValidPassword(password)
        
        if error != nil {
            showError(error!)
        }else if emailError != true{
            showError("Invalid email format.")
        }else if passwordError != true{
            showError("""
                        Password format:
                        at least one uppercase,
                        at least one digit,
                        at least one lowercase,
                        min 8 characters.
                        """)
        }else{
            self.errorLabel.alpha = 0
            guard let url = URL(string: "http://127.0.0.1:8000/api/login") else {
                return
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            let postString = "email=\(email)&password=\(password)"
            urlRequest.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    print("error = \(error!)")
                    DispatchQueue.main.async {
                        self.showError("Something went wrong. Please contact to administrator.")
                    }
                    return
                }
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(responseString!)
                
                if responseString == "userNotFound" {
                    DispatchQueue.main.async {
                        self.showError("User Not Found.")
                    }
                }else if responseString == "invalidCredentials" {
                    DispatchQueue.main.async {
                        self.showError("Invalid Credentials.")
                    }
                }else if responseString == "accountSuspended" {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error!", message: "Your account is suspended. Please contact to administrator.", preferredStyle: .alert)
                        let closeAction = UIAlertAction(title: "Close", style: .default)
                        alert.addAction(closeAction)
                        self.present(alert, animated: false, completion: nil)
                    }
                }else if responseString == "success" {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.set(email, forKey: "userEmail")
                        UserDefaults.standard.synchronize()
                        
                        let vc = UIStoryboard(name: "Main", bundle: nil)
                        let HomeVC = vc.instantiateViewController(identifier: "HomeVC")
                        HomeVC.modalPresentationStyle = .fullScreen
                        self.present(HomeVC, animated: false, completion: nil)
                    }
                }else {
                    DispatchQueue.main.async {
                        self.showError("Something went wrong.")
                    }
                }
            }
            task.resume()
        }
    }
    
    @IBAction func createAccountTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpViewController
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
    
    func validateFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "All fields are required."
        }
        return nil
    }
  
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func setUserDefaults(_ response: String){
        let json = """
        \(response)
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
            UserDefaults.standard.set(userRole, forKey: "userrole")
            UserDefaults.standard.set(userName, forKey: "userName")
            UserDefaults.standard.set(userContact, forKey: "userContact")
            UserDefaults.standard.set(userAddress, forKey: "userAddress")
        } else {
            print("Unable to retrieve data from JSON")
        }
    }
}
