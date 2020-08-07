//
//  UtilityFunctions.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-07.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


func configure<T>(_ entity: inout T, _ modify: (inout T) -> Void) -> T {
    modify(&entity)
    return entity
}
