//
//  AppQuerier.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation

typealias ResultHandler<T> = (Result<T, Error>) -> Void

extension GraphQLController: UserDataProvider {
    func logIn(_ completion: @escaping ResultHandler<User>) {
        completion(.failure(GraphQLError.unimplemented))
    }
}

extension GraphQLController: ImpactDataProvider {
    func fetchImpactStats(_ completion: @escaping ResultHandler<ImpactStats>) {
        completion(.failure(GraphQLError.unimplemented))
    }
}

extension GraphQLController: PickupDataProvider {
    func fetchAllPickups(_ completion: @escaping ResultHandler<[Pickup]>) {
        completion(.failure(GraphQLError.unimplemented))
    }
    
    func schedulePickup(_ pickupInput: Pickup.ScheduleInput,
                        completion: @escaping ResultHandler<Pickup.ScheduleResult>) {
        completion(.failure(GraphQLError.unimplemented))
    }
}
