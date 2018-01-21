//
//  ResultModel.swift
//  TesteWarren
//
//  Created by Adriano Soares on 21/01/2018.
//  Copyright © 2018 Adriano Soares. All rights reserved.
//

import Foundation

/*
 investmentProfile =         {
 "_id" = 5a640136c54c55483aa312f9;
 computedProfileType = passive1;
 computedRiskTolerance = 2;
 customer = 5a640136c54c55483aa312f4;
 isValid = 0;
 isVerified = 0;
 monthlyIncome = 30000;
 status = "deposit not set";
 };
 */

import ObjectMapper

class ResultModel: Mappable {
    var name: String!
    var computedRisk: String!
    var profileType: String!

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        name <- map["name"]
        computedRisk <- map["investmentProfile.computedProfileType"]
        profileType <- map["investmentProfile.computedRiskTolerance"]


    }

}
