//
//  BubbleController.swift
//  BubbleThoughts
//
//  Created by Trevor Walker on 7/29/19.
//  Copyright © 2019 Trevor Walker. All rights reserved.
//

import Foundation
import Firebase

class BubbleController{
    
    static let shared = BubbleController()
    var bubbles: [Bubble] = []
    
    func createProject(projectName: String) {
        guard let userUid = Auth.auth().currentUser?.uid else {return}
        
        let bubble = Bubble(lastChanged: Date(), projectName: projectName, bubbles: [], users: [userUid])
        bubbles.append(bubble)
        FirebaseStuff.shared.saveBubbles(bubble: bubble)
    }
    
    func deleteBubble(bubble: Bubble) {
        bubbles.remove(object: bubble)
        FirebaseStuff.shared.deleteBubbleRoom(bubble: bubble)
    }
    
    func generateRandomPastelColor(withMixedColor mixColor: UIColor?) -> UIColor {
        // Randomly generate number in closure
        let randomColorGenerator = { ()-> CGFloat in
            CGFloat(arc4random() % 256 ) / 256
        }
        
        var red: CGFloat = randomColorGenerator()
        var green: CGFloat = randomColorGenerator()
        var blue: CGFloat = randomColorGenerator()
        
        // Mix the color
        if let mixColor = mixColor {
            var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0;
            mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)
            red = (red + mixRed) / 2;
            green = (green + mixGreen) / 2;
            blue = (blue + mixBlue) / 2;
        }
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
