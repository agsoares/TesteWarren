//
//  SuitabilityAPI.swift
//  TesteWarren
//
//  Created by Adriano Soares on 17/01/2018.
//  Copyright © 2018 Adriano Soares. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class SuitabilityApi {
    let baseUrl = "https://dev-api.oiwarren.com/"

    func message (id: String?, answers: [String: Any], completion: @escaping (ResponseModel) -> () ) {
        let parameters : Parameters = [
            "context": "suitability",
            "id": id ?? NSNull(),
            "answers": answers
        ]


        Alamofire.request(baseUrl + "api/v2/conversation/message", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let message = Mapper<ResponseModel>().map(JSONObject: response.result.value) {
                    completion(message)
                }

        }
    }

    func finish (answers: [String: Any], completion: @escaping (ResultModel) -> () ) {
        let parameters : Parameters = [
            "answers": answers
        ]


        Alamofire.request(baseUrl + "api/v2/suitability/finish", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response.result.value)
                if let result = Mapper<ResultModel>().map(JSONObject: response.result.value) {
                    completion(result)
                }

        }
    }

}
