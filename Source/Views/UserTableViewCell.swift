//
//  UserTableViewCell.swift
//  TesteWarren
//
//  Created by Adriano Soares on 18/01/2018.
//  Copyright © 2018 Adriano Soares. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    var messageText = UILabel()
    var message: Message? {
        didSet {
            messageText.text = message?.value
        }

    }
    var avatarLetter: String? {
        didSet {
            avatar.text = avatarLetter ?? "?"
        }
    }

    let avatar = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        messageText.textAlignment = .right
        messageText.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(messageText)
        messageText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        messageText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        messageText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        messageText.numberOfLines = 0

        avatar.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatar)
        avatar.textAlignment = .center
        avatar.textColor = UIColor.white
        avatar.backgroundColor = UIColor.black

        avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        avatar.leadingAnchor.constraint(equalTo: messageText.trailingAnchor, constant: 10).isActive = true
        avatar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 26).isActive = true
        avatar.heightAnchor.constraint(equalTo: avatar.widthAnchor, multiplier: 1).isActive = true

        layoutIfNeeded()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        avatar.layer.cornerRadius = avatar.bounds.size.width/2
        avatar.clipsToBounds = true
    }
}
