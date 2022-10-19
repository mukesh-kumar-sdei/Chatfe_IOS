//
//  MemberIdMatchModel.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 09/08/22.
//

import Foundation

class MembersColorNMatch {
    let id: String?
    let matchType: String?
    let color: String?
    
    init(id: String, matchType: String, color: String) {
        self.id = id
        self.matchType = matchType
        self.color = color
    }
}


class MemberData {
    let _id : String?
    let fullname : String?
    let drinkImg : String?
    let matchType : String?
    
    init(_id: String, fullname: String, drinkImg: String, matchType: String) {
        self._id = _id
        self.fullname = fullname
        self.drinkImg = drinkImg
        self.matchType = matchType
    }
}
