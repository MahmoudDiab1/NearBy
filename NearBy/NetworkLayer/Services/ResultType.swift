//
//  ResultType.swift
//  NearBy
//
//  Created by mahmoud diab on 7/7/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

//MARK:-Responsbility : To capture data  or error in generic way.

enum Result<T,U> where U:Error {
    case success (T)
    case failure (U)
}
