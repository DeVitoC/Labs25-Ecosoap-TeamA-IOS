//
//  AppQuerier.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


typealias NetworkCompletion<T> = (Result<T, Error>) -> Void


class AppQuerier {
    private var networkService: GraphQLController
    private var token: String

    init(networkService: GraphQLController, token: String) {
        self.networkService = networkService
        self.token = token
    }

    private func query<T: Decodable>(
        expecting resultType: T.Type,
        query: String,
        options: [String: Any] = [:],
        completion: @escaping NetworkCompletion<T>
    ) {
        var variables: [String: Any] = ["token": token]
        options.forEach { key, value in variables[key] = value }
        networkService.queryRequest(T.self, query: query, completion: completion)
    }
}

extension AppQuerier: UserDataProvider {
    func logIn(_ completion: @escaping NetworkCompletion<User>) {
        query(expecting: User.self,
              query: GraphQLMutations.login,
              completion: completion)
    }
}

extension AppQuerier: PickupDataProvider {
    func fetchAllPickups(_ completion: @escaping NetworkCompletion<[Pickup]>) {
        fatalError("TODO")
    }

    func schedulePickup(
        _ pickupInput: Pickup.ScheduleInput,
        completion: @escaping NetworkCompletion<Pickup.ScheduleResult>
    ) {
        fatalError("TODO")
    }
}
