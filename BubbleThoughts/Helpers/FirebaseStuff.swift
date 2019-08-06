//
//  FirebaseStuff.swift
//  BubbleThoughts
//
//  Created by Trevor Walker on 7/26/19.
//  Copyright © 2019 Trevor Walker. All rights reserved.
//

import Foundation
import Firebase

class FirebaseStuff {
    
    static let shared = FirebaseStuff()
    let db = Firestore.firestore()
    
    func signup(username: String, email: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) /n--/n \(error)")
                completion(false, error)
                return
            }
            guard let user = user else {return}
            let currentUser = Auth.auth().currentUser;
            print(" User Created \(user)")
            let values = ["username": username, "email": email, "uid": currentUser?.uid]
            self.db.collection("users").document(currentUser!.uid).setData(values as [String : Any])
            completion(true, nil)
            print("Saved user to database")
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) /n--/n \(error)")
                completion(false)
                return
            }
            completion(true)
            return
        }
    }
    
    func saveBubbles(bubble: Bubble){
        let values: [String : Any] = ["bubbles" : bubble.bubbles, "users" : bubble.users, "lastChanged" : bubble.lastChanged, "projectName" : bubble.projectName, "uid" : bubble.uid]
        db.collection("BubbleRooms").document(bubble.uid).setData(values)
    }
    
    func updateBubbles(bubble: Bubble){
        let values: [String : Any] = ["bubbles" : bubble.bubbles, "users" : bubble.users, "lastChanged" : bubble.lastChanged, "projectName" : bubble.projectName, "uid" : bubble.uid]
        db.collection("BubbleRooms").document(bubble.uid).setData(values) { (error) in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) /n--/n \(error)")
            }
        }
    }
    func deleteBubbleRoom(bubble: Bubble){
        db.collection("BubbleRooms").document(bubble.uid).delete { (error) in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) /n--/n \(error)")
            } else{
                print("Worked bitch")
            }
        }
    }
    func pullBubbles(completion: @escaping (Bool) -> Void){
        guard let user = Auth.auth().currentUser?.uid else {return}
        db.collection("BubbleRooms").whereField("users", arrayContains: user as Any).getDocuments() { (querySnapshots, error) in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) /n--/n \(error)")
                completion(false)
            } else {
                for documents in querySnapshots!.documents {
                    
                    let bubble = Bubble(lastChanged: (documents.data()["lastChanged"] as! Timestamp).dateValue(), projectName: documents.data()["projectName"] as! String, bubbles: documents.data()["bubbles"] as! [String], users: documents.data()["users"] as! [String])
                    
                    BubbleController.shared.bubbles.append(bubble)
                }
                completion(true)
            }
        }
    }
}
