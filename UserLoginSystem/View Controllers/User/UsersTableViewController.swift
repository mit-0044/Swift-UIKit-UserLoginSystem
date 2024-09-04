//
//  UsersTableViewController.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 06/08/24.
//

import UIKit
import SideMenu

class UsersTableViewController: UITableViewController {
    
    var data = [Users]()
    @IBOutlet var userTableView: UITableView!
    var rowSelected = 0
    
    override func viewDidLoad() {
        UserDefaults.standard.removeObject(forKey: "selectedRowEmail")
        self.userList { result in
            self.data = result
            DispatchQueue.main.async {
                self.userTableView.reloadData()
            }
        }
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UsersTableViewCell
        cell.idLabel.text = String (indexPath.row + 1)
        cell.userNameLabel.text = data[indexPath.row].name
        cell.userEmailLabel.text = data[indexPath.row].email
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UserDefaults.standard.set(data[indexPath.row].email, forKey: "selectedRowEmail")
        if let vc = storyboard?.instantiateViewController(withIdentifier: "UserDetailsVC") as? UserDetailsViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - Navigation
    @IBAction func hamburgerTapped(_ sender: UIBarButtonItem) {
        let menu = SideMenuNavigationController(rootViewController: SidebarViewController())
        self.present(menu, animated: true, completion: nil)
    }
    
    private func userList(completion: @escaping ([Users]) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8000/api/user_list") else {
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if data != nil && error == nil {
                do{
                    let parsingData = try JSONDecoder().decode([Users].self, from: data!)
                    completion(parsingData)
                }catch{
                    print("error to parse the data.")
                }
            }
        }
        task.resume()
    }
}
