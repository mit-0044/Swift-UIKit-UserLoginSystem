//
//  Sidebar.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 01/08/24.
//

import UIKit

protocol SidebarDelegate {
    func hideHamburgerMenu()
}

class Sidebar: UIViewController {

    var delegate : SidebarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clickedOnButton(_ sender: Any) {
        self.delegate?.hideHamburgerMenu()
    }
    
    @IBAction func websiteUsersTapped(_ sender: UIButton) {
    }
    
    @IBAction func appUsersTapped(_ sender: UIButton) {
    }
    
    @IBAction func editProfileTapped(_ sender: UIButton) {
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        
    }
}
