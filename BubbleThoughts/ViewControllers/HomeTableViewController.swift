//
//  HomeTableViewController.swift
//  BubbleThoughts
//
//  Created by Trevor Walker on 7/29/19.
//  Copyright © 2019 Trevor Walker. All rights reserved.
//

import UIKit
import Firebase

class HomeTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        if Auth.auth().currentUser != nil {
            print("User logged in")
        } else {
            print("User Not logged in")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "notValidated", sender: nil)
            }
        }
        BubbleController.shared.bubbles = BubbleController.shared.bubbles.sorted(by: {
            $0.lastChanged.compare($1.lastChanged) == .orderedDescending})
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

override func viewDidLoad() {
    super.viewDidLoad()
    //self.navigationController?.isNavigationBarHidden = false
    FirebaseStuff.shared.pullBubbles { (completed) in
        if completed{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
@IBAction func signoutTapped(_ sender: Any) {
    presentSignOutAlert()
}
@IBAction func createNewTapped(_ sender: Any) {
    presentCreateAlert()
}

// MARK: - Table view data source
override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
}
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return BubbleController.shared.bubbles.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as? ProjectTableViewCell else {return UITableViewCell()}
    
    let bubble = BubbleController.shared.bubbles[indexPath.row]
    
    cell.projectNameLabel.text = bubble.projectName
    cell.lastEditDateLabel.text = bubble.lastChanged.formatDate()
    
    return cell
}

// Override to support editing the table view.
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        BubbleController.shared.deleteBubble(bubble: BubbleController.shared.bubbles[indexPath.row])
        DispatchQueue.main.async {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showProject"{
        guard let destination = segue.destination as? BubbleViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
        destination.bubble = BubbleController.shared.bubbles[indexPath.row]
    }
}
}

extension HomeTableViewController: UIAlertViewDelegate{
    func presentCreateAlert() {
        //Setting up Alert
        let alertController = UIAlertController(title: "Create Project", message: "Simply add the name", preferredStyle: .alert)
        //Customizing Alert
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Project Name"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
        }
        //Actions
        let addAction = UIAlertAction(title: "Create Project", style: .default) { (_) in
            guard let textInField = alertController.textFields?.first?.text else {return}
            if textInField != "" {
                BubbleController.shared.createProject(projectName: textInField)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .destructive)
        //Adding Actions
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        //Presenting Alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentSignOutAlert() {
        //Setting up Alert
        let alertController = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        //Actions
        let addAction = UIAlertAction(title: "Sign Out", style: .destructive) { (_) in
            do{
                try Auth.auth().signOut()
            } catch{
                return
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "notValidated", sender: nil)
            }
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .default)
        //Adding Actions
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        //Presenting Alert
        self.present(alertController, animated: true, completion: nil)
    }
}
