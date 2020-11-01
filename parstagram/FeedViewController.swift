//
//  FeedViewController.swift
//  parstagram
//
//  Created by Sara Kazemi on 10/23/20.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MessageInputBarDelegate {

    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    
    let commentBar = MessageInputBar()
    var showsCommentBar = false;
    var posts = [PFObject]()
    var selectedPost: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className:"Post")
        query.includeKeys(["username", "comments", "comments.author"])
        query.limit = 20
        query.findObjectsInBackground() { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //Create the comment
        let comment = PFObject(className: "Comments")
        
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!

        selectedPost.add(comment, forKey: "comments")
        selectedPost.saveInBackground { (success, error) in

            if success {
                print("comment successfully saved")
            }
            else {
                print("error saving comment")
            }
        }
        
        tableView.reloadData()
        
        // Clear and dismiss the input
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // number of posts plus all the comments under each post AND the addCommentCell
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? [] // if no comments, return empty array
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // number of sections
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? [] // if no comments, return empty array
        
        if indexPath.row == 0 {
            // this is a post cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            let user = post["username"] as! PFUser
            cell.usernameLabel.text = user.username
            cell.captionLabel.text = post["description"] as! String
            
            let imageFile = post["image"] as! PFFileObject
                  let urlString = imageFile.url!
                  let url = URL(string: urlString)!
                  
                  cell.photoView.af_setImage(withURL: url)
                  
                  return cell
        }
        else if indexPath.row <= comments.count {
            // this is a comment cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commenterPost.text = comment["text"] as? String
            let user = comment["author"] as! PFUser
            cell.commenterName.text = user.username
            
            return cell
        }
        
        else {
            // this is the add a comment cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
        
        
              
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        // create Comment object
        let comments = (post["comments"] as? [PFObject]) ?? [] // if no comments, return empty array
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        sceneDelegate.window?.rootViewController = loginViewController
    }
    
    @IBAction func onClickCamera(_ sender: Any) {
        print("camera")
    }
}
