//
//  SidebarViewController.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 02/08/24.
//

import UIKit
import SideMenu

protocol SideMenuViewControllerDelegate {
    func didSelectCell(_ row: Int, title: String)
}

class SidebarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var sideMenuTableView: UITableView!
    var delegate: SideMenuViewControllerDelegate?
    var menuArray: [String] = []
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var profileView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    let userID = UserDefaults.standard.string(forKey: "userID")
    let userRole = UserDefaults.standard.string(forKey: "userRole")
    let userName = UserDefaults.standard.string(forKey: "userName")
    let userEmail = UserDefaults.standard.string(forKey: "userEmail")
    let userContact = UserDefaults.standard.string(forKey: "userContact")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = userName
        emailLabel.text = userEmail
        if userRole == "Admin" {
            menuArray = ["Home", "Manage Users", "Profile"]
        } else {
            menuArray = ["Home", "Profile"]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.menuArray.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let label = cell.contentView.viewWithTag(1) as! UILabel
        label.font = label.font.withSize(20)
        label.text = self.menuArray[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        if currentCell.textLabel!.text! == "Home" {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false, completion: nil)
            
        }else if currentCell.textLabel!.text! == "Manage Users" {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UsersTableVC") as! UsersTableViewController
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false, completion: nil)
            
        }else if currentCell.textLabel!.text! == "Profile" {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false, completion: nil)
            
        }
    }
}
