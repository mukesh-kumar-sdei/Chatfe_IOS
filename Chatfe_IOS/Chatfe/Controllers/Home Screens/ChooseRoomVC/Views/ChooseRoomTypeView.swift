//
//  ChooseRoomTypeView.swift
//  Chatfe
//
//  Created by Piyush Mohan on 03/05/22.
//

import UIKit

class ChooseRoomTypeView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.inputViewController?.navigationController?.popViewController(animated: true)
    }
    @IBAction func publicRoomTapped(_ sender: UIButton) {
        debugPrint("Tapped!")
//        let storyboard = UIStoryboard(name: "HomeViews", bundle: nil)
//        let nextVC = storyboard.instantiateViewController(withIdentifier: "CreatePublicRoomViewController") as! CreatePublicRoomViewController
        //self.inputViewController?.navigationController?.pushViewController(nextVC, animated: true)
//        self.present(nextVC, animated: true)
//        let storyboard = UIStoryboard(name: "HomeViews", bundle: nil)
//        let nextVC = storyboard.instantiateViewController(withIdentifier: "CreatePublicRoomViewController") as! CreatePublicRoomViewController
//        self.inputViewController?.navigationController?.pushViewController(nextVC, animated: true)
     }
    @IBAction func privateRoomTapped(_ sender: UIButton) {
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ChooseRoomTypeView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ChooseRoomTypeView", bundle: nil).instantiate(withOwner: nil)[0] as! UIView
    }

}
