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
    
    func signup(username: String, email: String, password: String, image: UIImage, completion: @escaping (Bool, Error?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) /n--/n \(error)")
                completion(false, error)
                return
            }
            guard let user = user else {return}
            let currentUser = Auth.auth().currentUser;
            print(" User Created \(user)")
            self.uploadImage(image: image, completion: { (url) in
                let values = ["username": username, "email": email, "uid": currentUser?.uid, "imageURL": url]
                self.db.collection("users").document(currentUser!.uid).setData(values as [String : Any])
                completion(true, nil)
                print("Saved user to database")
            })
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
    
    func updateBubbles(bubble: Bubble){
        let values: [String : Any] = ["bubbles" : bubble.bubbles, "users" : bubble.users, "lastChanged" : bubble.lastChanged, "projectName" : bubble.projectName, "uid" : bubble.uid]
        print(bubble.uid)
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
                print("Deleted Bubble")
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
                    
                    let bubble = Bubble(lastChanged: (documents.data()["lastChanged"] as! Timestamp).dateValue(), projectName: documents.data()["projectName"] as! String, bubbles: documents.data()["bubbles"] as! [String], users: documents.data()["users"] as! [String], uid:  documents.data()["uid"] as? String)
                    
                    BubbleController.shared.bubbles.append(bubble)
                }
                completion(true)
            }
        }
    }
    func uploadImage(image: UIImage, completion: @escaping (String?) -> Void){
        guard let data = image.jpegData(compressionQuality: 1.0), let uid = Auth.auth().currentUser?.uid  else {print("Image Failed to upload"); return}
        let imageRefrence = Storage.storage().reference().child("profileImages").child("\(uid)ProfilePic")
        imageRefrence.putData(data, metadata: nil) { (metaData, error) in
            if error != nil{
                print("Error uploading Image")
            }
            imageRefrence.downloadURL(completion: { (url, error) in
                if error != nil{
                    print("Error uploading Image")
                }
                guard let url = url else {return}
                completion(url.absoluteString)
            })
        }
    }
}
