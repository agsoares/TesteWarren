//
//  BotTableViewCell.swift
//  TesteWarren
//
//  Created by Adriano Soares on 18/01/2018.
//  Copyright © 2018 Adriano Soares. All rights reserved.
//

import UIKit

class BotTableViewCell: UITableViewCell {
    var messageText = UILabel()
    var message: Message? {
        didSet {
            messageText.text = message?.value
        }

    }

    let avatar = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        messageText.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(messageText)

        messageText.translatesAutoresizingMaskIntoConstraints = false
        messageText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        messageText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        messageText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        messageText.numberOfLines = 0

        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.image = UIImage(named: "logo_suita")
        contentView.addSubview(avatar)


        avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        avatar.trailingAnchor.constraint(equalTo: messageText.leadingAnchor, constant: -10).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 26).isActive = true
        avatar.heightAnchor.constraint(equalTo: avatar.widthAnchor, multiplier: 1).isActive = true

        layoutIfNeeded()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



}
