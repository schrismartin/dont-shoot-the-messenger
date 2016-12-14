//
//  FBMessageInformation.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/14/16.
//
//

import Foundation
import Vapor
import HTTP

public struct FBIncomingMessage {
    public var senderId: SCMIdentifier
    public var recipientId: SCMIdentifier
    public var date: Date
    public var text: String?
    public var postback: String?

    /// Constructs an expected Facebook Messenger event from the received JSON data
    /// - Parameter json: The JSON payload representation of an event
    /// Fails if
    public init?(json: JSON) {
        
        // Extract Components
        guard let senderId = json[ "sender" ]?[ "id" ]?.string,
            let recipientId = json[ "recipient" ]?[ "id" ]?.string,
            let timestamp = json[ "timestamp" ]?.int else {
                console.log("Facebook Message must contain senderId, recipientId, and timestamp")
                return nil
        }
        
        // Make assignments
        self.senderId = SCMIdentifier(string: senderId)
        self.recipientId = SCMIdentifier(string: recipientId)
        self.date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        self.text = json[ "message" ]?[ "text" ]?.string
        self.postback = json[ "postback" ]?[ "payload" ]?.string
        
        // Error Checking
        guard postback != nil || text != nil else {
            console.log("Facebook Message must contain either message or payload")
            return nil
        }
    }
}

extension FBIncomingMessage: CustomStringConvertible {
    public var description: String {
        return "Sender: \(senderId.string), Recipient: \(recipientId.string), Message: \(text), date: \(date)"
    }
}
