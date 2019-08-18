//
//  BubbleViewController.swift
//  BubbleThoughts
//
//  Created by Trevor Walker on 7/31/19.
//  Copyright © 2019 Trevor Walker. All rights reserved.
//

import UIKit
import Magnetic

class BubbleViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var bubble: Bubble!
    var currentNode: [Node] = []
    var magnetic: Magnetic {
        return magneticView.magnetic
    }
    
    @IBOutlet weak var magneticView: MagneticView! {
        didSet {
            magnetic.magneticDelegate = self as MagneticDelegate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
        deleteButton.clipsToBounds = true
        deleteButton.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let bubble = bubble else {return}
        for word in bubble.bubbles{
            self.addBubble(text: word)
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 15
    }
    
    func addBubble(text: String){
        let label = UILabel()
        label.text = text
        var radius = label.intrinsicContentSize.width / 2
        if (radius < 15){
            radius = 15
        }
        let node = Node(text: text, image: nil, color: BubbleController.shared.generateRandomPastelColor(withMixedColor: nil), radius: CGFloat(radius))
        self.magnetic.addChild(node)
    }
    func checkButton(){
        if currentNode.count != 0{
           deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
    }
    
    @IBAction func createBubble(_ sender: UIBarButtonItem) {
        presentAlert()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteBubble(_ sender: Any) {
        for node in currentNode{
            node.removeFromParent()
            if let index = bubble.bubbles.firstIndex(of: node.text ?? ""){
                bubble.bubbles.remove(at: index)
                guard let nodeIndex = self.currentNode.firstIndex(of: node) else {return}
                currentNode.remove(at: nodeIndex)
            }
        }
        FirebaseStuff.shared.updateBubbles(bubble: bubble)
        checkButton()
    }
}


// MARK: - MagneticDelegate
extension BubbleViewController: MagneticDelegate {
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        currentNode.append(node)
        print("didSelect -> \(node)")
        node.strokeColor = .black
        checkButton()
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        if let index = currentNode.firstIndex(of: node){
            currentNode.remove(at: index)
        }
        print("didDeselect -> \(node)")
        node.strokeColor = .clear
        checkButton()
    }
    
}

extension BubbleViewController: UIAlertViewDelegate{
    func presentAlert() {
        //Setting up Alert
        let alertController = UIAlertController(title: "Add Bubble", message: "Max of 15 characters", preferredStyle: .alert)
        //Customizing Alert
        alertController.addTextField { (textField) -> Void in
            textField.delegate = self
            textField.placeholder = "Text"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
        }
        //Actions
        let addAction = UIAlertAction(title: "AddBubble", style: .default) { (_) in
            guard let textInField = alertController.textFields?.first?.text else {return}
            if textInField != "" {
                self.addBubble(text: textInField)
                self.bubble.bubbles.append(textInField)
                FirebaseStuff.shared.updateBubbles(bubble: self.bubble)
            }
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel)
        //Adding Actions
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        //Presenting Alert
        self.present(alertController, animated: true, completion: nil)
    }
}
