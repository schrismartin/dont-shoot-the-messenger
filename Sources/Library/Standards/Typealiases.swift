//
//  Typealiases.swift
//  the-narrator
//
//  Created by Chris Martin on 12/21/16.
//
//

import Foundation
import MongoKitten
import HTTP
import JSON

/// Closure for use with asyncronous network requests.
/// - Parameter response: Response from the asyncronous request. `nil` if request failed altogether.
public typealias ResponseBlock = (Response?) -> (Void)
