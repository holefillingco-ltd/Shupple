//
//  ChatViewController.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/09/13.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    private let currentUserUid = Auth.auth().currentUser?.uid
    var opponentUid: String?
    
    @IBOutlet weak var header: UINavigationBar!
    
    var ref: DatabaseReference!
    var messages: [JSQMessage]?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var incomingAvatar: JSQMessagesAvatarImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    var safeArea: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputToolbar!.contentView!.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        
        self.senderId = currentUserUid
        self.senderDisplayName = currentUserUid
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        self.messages = []
        setupFirebase()
        
        safeArea = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 44))
        header.frame = CGRect(x: 0, y: 44, width: view.frame.width, height: 44)
        header.barTintColor = .grayEndColor
        header.isTranslucent = false
        safeArea?.backgroundColor = .grayEndColor
        view.addSubview(header)
        view.addSubview(safeArea!)
    }
    
    func setupFirebase() {
        let ch = Channel(myId: currentUserUid!, opponentId: opponentUid!)
        ref = Database.database().reference().child(ch.id!)
        
        ref.queryLimited(toLast: 25).observe(DataEventType.childAdded, with: {
            (snapshot) in
            let snapshotValue = snapshot.value as! NSDictionary
            let text = snapshotValue["text"] as! String
            let sender = snapshotValue["from"] as? String
            let name = snapshotValue["name"] as? String
            let message = JSQMessage(senderId: sender, displayName: name, text: text)
            self.messages?.append(message!)
            self.finishSendingMessage()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        self.finishReceivingMessage(animated: true)
        
        let post = ["from": senderId, "name": senderDisplayName, "text": text]
        let post1Ref = ref.childByAutoId()
        post1Ref.setValue(post)
        self.finishSendingMessage(animated: true)
        
        self.view.endEditing(true)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages![indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    // アイテムごとにアバター画像を返す
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingAvatar
        }
        return self.incomingAvatar
    }
    
    // アイテムの総数を返す
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages!.count
    }
}
