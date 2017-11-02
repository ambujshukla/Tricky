//
//  ChatData.swift
//  Tricky
//
//

import UIKit
import RealmSwift

class ChatData : Object
{
    dynamic var message = ""
    dynamic var isFavorite = 0
    dynamic var messageId = ""
    dynamic var senderId = ""
    dynamic var time = ""
    dynamic var type = ""
    dynamic var receiverId = ""
    dynamic var timeStamp = 0
    dynamic var chatId = ""
}
