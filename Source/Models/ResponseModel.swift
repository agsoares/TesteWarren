//
//  ResponseModel.swift
//  TesteWarren
//
//  Created by Adriano Soares on 17/01/2018.
//  Copyright © 2018 Adriano Soares. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class ResponseModel: Mappable {
    var id: String!
    var buttons: [Button]!
    var messages: [Message]!
    var inputs: [Input]!
    var responses: [String]!


    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        buttons <- map["buttons"]
        messages <- map["messages"]
        inputs <- map ["inputs"]
        responses <- map ["responses"]

    }

}

struct Message: Mappable {
    var value: String!
    var isUserMessage = false;

    init(value: String, isUserMessage: Bool) {
        self.value = value
        self.isUserMessage = isUserMessage
    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        value <- map["value"]
    }

}

struct Input: Mappable {
    var type: String!
    var mask: String!
    var keyboardType: UIKeyboardType = .default

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        mask <- map["mask"]
        type <- map["type"]

        switch type {
        case "number":
            keyboardType = .numberPad
        default:
            keyboardType = .default
        }
    }

}

struct Button: Mappable {
    var value: String!
    var label: String!

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        value <- map["value"]
        label <- map["label.title"]
    }

}
