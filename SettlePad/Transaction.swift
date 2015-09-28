//
//  Transaction.swift
//  SettlePad
//
//  Created by Rob Everhardt on 02/01/15.
//  Copyright (c) 2015 SettlePad. All rights reserved.
//

import Foundation

class Transaction {	
    var time_sent: NSDate
    var time_updated: NSDate
	var primaryIdentifierStr: String? //Primary identifier of counterpart
	var usedIdentifierStr: String  //Identifier of counterpart used in transaction
	var name: String
    var is_sender: Bool
    var transaction_id: Int?
    var description: String
    var currency: Currency
    var amount: Double
    var status: transactionStatus
    var reduced: Bool

    var can_be_canceled: Bool {
        get {
            let now = NSDate()
            let minfourDate = now.dateByAddingTimeInterval(NSTimeInterval(-60*4)) //in seconds
            if
                status == .Draft || //if in draft
				(is_sender == true && status == .AwaitingValidation) || //Has not been accepted yet
				(is_sender == true && status == .Processed && time_sent.compare(minfourDate) != NSComparisonResult.OrderedAscending) //only for last five minutes in API, so show four
            {
                return true
            } else {
                return false
            }
        }
    }
    var can_be_accepted: Bool {
        get {
            if status == .AwaitingValidation && self.is_sender == false {
                return true
            } else {
                return false
            }
        }
    }
    
    enum transactionStatus {
        case Draft
        case Posted
        case Processed
        case AwaitingValidation
        case CanceledOrRejected
    }
    
    init(fromDict: NSDictionary = [:]) {
        if let parsed = fromDict["status"] as? Int {
            //0 = processed, 1 = waiting for validation by recipient, 3 = canceled or rejected
            switch parsed {
            case 0:
                status = .Processed
            case 1:
                status = .AwaitingValidation
            case 3:
                status = .CanceledOrRejected
            default:
                print("Unknown status parameter")
                status = .Processed
            }
        } else {
            status = .Processed
            print("Failed to get status parameter")
        }
        
        if let time_sentString = fromDict["time_sent"] as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let parsed = dateFormatter.dateFromString(time_sentString) { //NSDate
                time_sent = parsed
            } else {
                time_sent = NSDate()
                print("Failed to parse time_sent parameter")
            }
        } else {
            time_sent = NSDate()
            print("Failed to get time_sent parameter")
        }

        if let time_updatedString = fromDict["time_updated"] as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let parsed = dateFormatter.dateFromString(time_updatedString) { //NSDate
                time_updated = parsed
            } else {
                time_updated = NSDate()
                print("Failed to parse time_updated parameter")
            }
        } else {
            time_updated = NSDate()
            print("Failed to get time_updated parameter")
        }
		
		if let counterpartName = fromDict["counterpart_name"] as? String {
			name = counterpartName
		} else {
			name = ""
            print("Failed to get counterpart name")
        }

		if let counterpartIdentifier = fromDict["counterpart_primary_identifier"] as? String {
			primaryIdentifierStr = counterpartIdentifier
		} else {
			primaryIdentifierStr = nil
		}
		
		
		if let counterpartUsedIdentifier = fromDict["counterpart_used_identifier"] as? String {
			usedIdentifierStr = counterpartUsedIdentifier
		} else {
			usedIdentifierStr = ""
			print("Failed to get counterpart used identifier")
		}
		
        if let parsed = fromDict["is_sender"] as? Int {
            if (parsed == 1) {
                is_sender = true
            } else {
                is_sender = false
            }
        } else {
            is_sender = false
            print("Failed to get is_sender parameter")
        }
        
        if let parsed = fromDict["transaction_id"] as? Int {
            transaction_id = parsed
        } else {
            transaction_id = nil
            print("Failed to get transaction_id parameter")
        }
        
        if let parsed = fromDict["description"] as? String {
            description = parsed
        } else {
            description = ""
            print("Failed to get description parameter")
        }
        
        if let parsed = fromDict["currency"] as? String {
			if let parsedCurrency = Currency(rawValue: parsed) {
				currency = parsedCurrency
			} else {
				currency = Currency.EUR
				print("Unknown currency parameter")
			}
        } else {
			currency = Currency.EUR
			print("Failed to get currency parameter")
        }
        
        if let parsed = fromDict["amount"] as? Double {
            amount = parsed
        } else {
            amount = 0
            print("Failed to get amount parameter")
        }
        
        if let parsed = fromDict["reduced"] as? Int {
            if (parsed == 1) {
                reduced = true
            } else {
                reduced = false
            }
        } else {
            reduced = false
            print("Failed to get reduced parameter")
        }
    }
    
	init(name: String, identifier: String, description: String, currency: Currency, amount: Double) {
        time_sent = NSDate()
        time_updated = NSDate()
        self.name = name
		self.primaryIdentifierStr = identifier
		self.usedIdentifierStr = identifier
        is_sender = true
        transaction_id = nil
        self.description = description
        self.currency = currency
        self.amount = amount
        status = .Draft
        reduced = false
    }
}