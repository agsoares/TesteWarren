//
//  ResultViewController.swift
//  TesteWarren
//
//  Created by Adriano Soares on 21/01/2018.
//  Copyright © 2018 Adriano Soares. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    var result: ResultModel?

    var youProfireIs = UILabel()
    var profileLabel = UILabel()


    var gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        youProfireIs.text = "O SEU PERFIL É"

        profileLabel.text = result?.profileType ?? "Passivo"

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLayout()
    }

    func configureLayout () {
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red:0.93, green:0.20, blue:0.37, alpha:1.00).cgColor,
                                UIColor(red:0.99, green:0.55, blue:0.15, alpha:1.00).cgColor]
        self.view.layer.addSublayer(gradientLayer)


        youProfireIs.textColor = UIColor.white
        youProfireIs.font = UIFont.boldSystemFont(ofSize: 14)

        youProfireIs.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(youProfireIs)

        youProfireIs.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        youProfireIs.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true

        profileLabel.textColor = UIColor.white
        profileLabel.font = UIFont.boldSystemFont(ofSize: 40)

        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileLabel)

        profileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        profileLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true


    }

}
