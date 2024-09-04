//
//  UsersViewController.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 06/08/24.
//

import UIKit
import IPImage

class UsersViewController: UIViewController{
    
    var data = [Users]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUsers { res in
            self.data = res
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func getUsers(completion: @escaping ([Users]) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8000/api/getUsers") else {
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

extension UsersViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UsersTableViewCell
        cell.idLabel.text = String (indexPath.row + 1)
        cell.nameLabel.text = data[indexPath.row].name
        cell.emailLabel.text = data[indexPath.row].email
        return cell
    }

}
