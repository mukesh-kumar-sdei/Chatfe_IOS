//
//  EmojiReaction.swift
//  Chatfe
//
//  Created by Mukesh Kumar on 08/08/22.
//

import Foundation
import ReactionButton

final class EmojiReaction: ReactionButton, ReactionButtonDataSource, ReactionButtonDelegate {
    
    let optionsDataset = [
        (imageName: "Emoji-1", title: "Like"),
        (imageName: "Emoji-2", title: "Smile"),
        (imageName: "Emoji-3", title: "Heart"),
        (imageName: "Emoji-4", title: "Idea"),
        (imageName: "Emoji-5", title: "Slow"),
        (imageName: "Emoji-6", title: "Fast")
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dataSource = self
    }
    
    func numberOfOptions(in selector: ReactionButton) -> Int {
        optionsDataset.count
    }
    
    func ReactionSelector(_ selector: ReactionButton, viewForIndex index: Int) -> UIView {
        let option = optionsDataset[index].imageName
        guard let image = UIImage(named: option) else {
            return UIView()
        }
        return UIImageView(image: image)
    }
    
    func ReactionSelector(_ selector: ReactionButton, nameForIndex index: Int) -> String {
        optionsDataset[index].title
    }
    
}
