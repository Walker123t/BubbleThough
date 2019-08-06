//
//  BubbleViewController.swift
//  BubbleThoughts
//
//  Created by Trevor Walker on 7/31/19.
//  Copyright © 2019 Trevor Walker. All rights reserved.
//

import UIKit
import Magnetic

class BubbleViewController: UIViewController {
    
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let bubble = bubble else {return}
        for word in bubble.bubbles{
            self.addBubble(text: word)
        }
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
    
    @IBAction func createBubble(_ sender: UIBarButtonItem) {
        presentAlert()
    }
    
    @IBAction func deleteBubble(_ sender: Any) {
        for node in currentNode{
            node.removeFromParent()
            if let index = bubble.bubbles.firstIndex(of: node.text ?? ""){
                bubble.bubbles.remove(at: index)
            }
        }
        FirebaseStuff.shared.updateBubbles(bubble: bubble)
    }
}

// MARK: - MagneticDelegate
extension BubbleViewController: MagneticDelegate {
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        currentNode.append(node)
        print("didSelect -> \(node)")
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        if let index = currentNode.firstIndex(of: node){
            currentNode.remove(at: index)
        }
        print("didDeselect -> \(node)")
    }
    
}

extension BubbleViewController: UIAlertViewDelegate{
    func presentAlert() {
        //Setting up Alert
        let alertController = UIAlertController(title: "Add Bubble", message: "Just add your thought", preferredStyle: .alert)
        //Customizing Alert
        alertController.addTextField { (textField) -> Void in
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
        let cancelAction = UIAlertAction(title:"Cancel", style: .destructive)
        //Adding Actions
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        //Presenting Alert
        self.present(alertController, animated: true, completion: nil)
    }
}
