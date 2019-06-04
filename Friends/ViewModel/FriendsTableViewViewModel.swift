//
//  FriendsTableViewViewModel.swift
//  Friends
//
//  Created by VALID on 5/31/19.
//  Copyright © 2019 VALID Colombia. All rights reserved.
//
class FriendsTableViewViewModel {
    
    enum FriendTableViewCellType {
        case normal(cellViewModel: FriendCellViewModel)
        case error (message: String)
        case empty
    }
    
    var showLoadingHud: Bindable = Bindable(false)
    
    let friendCells = Bindable([FriendTableViewCellType]())
    let appServerClient : AppServerClient
    
    init(appServerClient:AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    
    func getFriends() {
        showLoadingHud.value = true
        appServerClient.getFriends(completion: { [weak self] result in
            self?.showLoadingHud.value = false
            switch result {
            case .success(let friends):
                guard friends.count > 0 else {
                    self?.friendCells.value = [.empty]
                    return
                }
                self?.friendCells.value = friends.compactMap{ .normal(cellViewModel: $0 as FriendCellViewModel)}
            case .failure(let error):
                self?.friendCells.value = [.error(message: error?.getErrorMessage() ?? "Loading failed, check network connection")]
            }
        })
    }
}
// MARk: AppServerClient.GetFriendsFailureReason
fileprivate extension AppServerClient.GetFriendsFailureReason {
    func getErrorMessage() -> String? {
        switch self {
        case .unAuthorized:
            return "Please login to load your friends."
        case .notFound:
            return "Could not complete request, please try again"
        }
    }
}

