//
//  AuthorChatViewController.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/10/02.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class AuthorChatViewController: JSQMessagesViewController {

    private let currentUserUid = Auth.auth().currentUser?.uid
    let AuthorId = "diorclub8isozakiauthor"
    
    var ref: DatabaseReference!
    var messages: [JSQMessage]?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var incomingAvatar: JSQMessagesAvatarImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyScrollsToMostRecentMessage = true
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        self.senderId = currentUserUid
        self.senderDisplayName = currentUserUid
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        self.messages = []
        setupFirebase()
        self.navigationItem.title = "運営チャット"
    }

    func setupFirebase() {
        let ch = AuthorId + "-" + currentUserUid!
        ref = Database.database().reference().child(ch)
        
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
    
    //時刻表示のための高さ調整
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let message = messages![indexPath.item]
        if indexPath.item == 0 {
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = messages![indexPath.item - 1]
            if message.date.timeIntervalSince(previousMessage.date) / 60 > 1 {
                return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
            }
        }
        return nil
    }
    
    // 送信時刻を出すために高さを調整する
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        
        if indexPath.item == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = messages![indexPath.item - 1]
            let message = messages![indexPath.item]
            if message.date .timeIntervalSince(previousMessage.date) / 60 > 1 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        return 0.0
    }
}
