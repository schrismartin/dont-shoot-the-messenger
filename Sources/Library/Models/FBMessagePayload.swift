//
//  FBMessageInformation.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/14/16.
//
//

import Foundation

public struct FBMessagePayload {
    public var senderId: SCMIdentifier
    public var recipientId: SCMIdentifier
    public var date: Date
    public var message: String
}

extension FBMessagePayload: CustomStringConvertible {
    public var description: String {
        return "Sender: \(senderId.string), Recipient: \(recipientId.string), Message: \(message), date: \(date)"
    }
}
