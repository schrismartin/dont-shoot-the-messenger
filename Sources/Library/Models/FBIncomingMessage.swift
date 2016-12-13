//
//  FBMessageInformation.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/14/16.
//
//

import Foundation

public struct FBIncomingMessage {
    public var senderId: SCMIdentifier
    public var recipientId: SCMIdentifier
    public var date: Date
    public var text: String?
    public var postback: String?
}

extension FBIncomingMessage: CustomStringConvertible {
    public var description: String {
        return "Sender: \(senderId.string), Recipient: \(recipientId.string), Message: \(text), date: \(date)"
    }
}
