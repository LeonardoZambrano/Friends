//
//  AppServerClient.swift
//  Friends
//
//  Created by VALID on 5/30/19.
//  Copyright © 2019 VALID Colombia. All rights reserved.
//

import Alamofire
import RxSwift

// Mark: AppServerClient
class AppServerClient {
    //Mark: GetFriends
    enum GetFriendsFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
   
    func getFriends() -> Observable <[Friend]> {
        return Observable.create {observer -> Disposable in
        Alamofire.request("http://friendservice.herokuapp.com/listFriends")
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        observer.onError(response.error ?? GetFriendsFailureReason.notFound)
                        return
                    }
                    do {
                        let friends = try JSONDecoder().decode([Friend].self, from: data)
                        observer.onNext(friends)
                    } catch {
                        observer.onError(error)
                    }
                    
                case .failure( let error):
                    if let statusCode = response.response?.statusCode,
                        let reason = GetFriendsFailureReason(rawValue: statusCode) {
                        observer.onError(reason)
                    }
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
