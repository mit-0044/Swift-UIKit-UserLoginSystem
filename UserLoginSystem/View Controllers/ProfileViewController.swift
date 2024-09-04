//
//  SettingViewController.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 18/07/24.
//

import UIKit
import SideMenu

class ProfileViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var roleLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    let userName = UserDefaults.standard.string(forKey: "userName")
    let userRole = UserDefaults.standard.string(forKey: "userRole")
    let userEmail = UserDefaults.standard.string(forKey: "userEmail")
    let userContact = UserDefaults.standard.string(forKey: "userContact")
    let userAddress = UserDefaults.standard.string(forKey: "userAddress")
    
    override func viewDidLoad() {
        nameLabel.text = userName
        roleLabel.text = userRole
        emailLabel.text = userEmail
        contactLabel.text = userContact
        addressLabel.text = userAddress ?? "Address not found."
        super.viewDidLoad()
    }
    
    @IBAction func hamburgerTapped(_ sender: UIBarButtonItem) {
        let menu = SideMenuNavigationController(rootViewController: SidebarViewController())
        self.present(menu, animated: true, completion: nil)
    }
    
    @IBAction func updateButtonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateProfileVC") as! UpdateProfileViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false, completion: nil)
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive, handler: { (action) in
            self.logoutUser()
        })
        alert.addAction(logoutAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: false, completion: nil)
    }
    
    private func logoutUser(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}
