//
//  FriendsTableViewViewModel.swift
//  Friends
//
//  Created by VALID on 5/31/19.
//  Copyright © 2019 VALID Colombia. All rights reserved.
//

import RxSwift
import RxCocoa

enum FriendTableViewCellType {
    case normal(cellViewModel: FriendCellViewModel)
    case error (message: String)
    case empty
}

class FriendsTableViewViewModel {
    
    var friendCells : Observable <[FriendTableViewCellType]> {
        return cells.asObservable()
    }
    
    var onShowLoadingHud: Observable <Bool> {
        return loadInProgress
        .asObservable()
        .distinctUntilChanged()
    }
    
    //let onShowError = PublishSubject()
    let appServerClient : AppServerClient
    let disposeBag = DisposeBag()
    
    private let loadInProgress = BehaviorRelay(value: false)
    private let cells = BehaviorRelay <[FriendTableViewCellType]>(value: [])
    
    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    
    func getFriends() {
        loadInProgress.accept(true)
        
        appServerClient
        .getFriends()
        .subscribe (
            onNext : {[weak self] friends in
                self?.loadInProgress.accept(false)
                guard friends.count > 0 else {
                    self?.cells.accept([.empty])
                    return
                }
                self?.cells.accept(friends.compactMap {
                    .normal(cellViewModel: FriendCellViewModel(friend: $0)) }
            )},
            onError : {[weak self] error in
                self?.loadInProgress.accept(false)
                self?.cells.accept([
                    .error(
                    message: (error as?
                    AppServerClient.GetFriendsFailureReason)?.getErrorMessage() ?? "Loading failed, check network connection"
                    )
                    ])
            }
        )
            .disposed(by: disposeBag)
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

