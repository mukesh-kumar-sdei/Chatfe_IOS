//
//  SaveFriendsModel.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 21/06/22.
//

import Foundation


class SaveFriendsModel: NSObject {
    
    let id : String?
    let fullname : String?
    let profileImg : String?
    
    init(id: String?, fullname: String?, profileImg: String?) {
        self.id = id
        self.fullname = fullname
        self.profileImg = profileImg
    }
}
