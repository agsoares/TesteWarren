//
//  UILabel+Animation.swift
//  TesteWarren
//
//  Created by Adriano Soares on 18/01/2018.
//  Copyright © 2018 Adriano Soares. All rights reserved.
//

import UIKit

extension UILabel {

    func animate(newText: String, characterDelay: TimeInterval) {

        DispatchQueue.main.async {

            self.text = ""

            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }

}
