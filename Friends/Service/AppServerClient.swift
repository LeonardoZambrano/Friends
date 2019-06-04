//
//  AppServerClient.swift
//  Friends
//
//  Created by VALID on 5/30/19.
//  Copyright © 2019 VALID Colombia. All rights reserved.
//

import Alamofire

// Mark: AppServerClient
class AppServerClient {
    //Mark: GetFriends
    enum GetFriendsFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
    
    typealias GetFriendsResult = Result<[Friend], GetFriendsFailureReason>
    typealias GetFriendsCompletion = (_ result: GetFriendsResult) -> Void
    
    func getFriends(completion: @escaping GetFriendsCompletion) {
        Alamofire.request("http://friendservice.herokuapp.com/listFriends")
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let jsonArray = response.result.value as? [JSON] else {
                        completion(.failure(nil))
                        return
                    }
                    completion(.success(payload: jsonArray.compactMap {
                        Friend(json: $0)
                    }))
                    //completion(.success(payload: []))
                case .failure(_):
                    if let statusCode = response.response?.statusCode,
                        let reason = GetFriendsFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
            }
    }
}
