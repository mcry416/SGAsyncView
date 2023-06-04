//
//  AsyncDrawViewController.swift
//  Compent
//
//  Created by Eldest's MacBook on 2023/5/18.
//

import UIKit

class AsyncDrawViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 20, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - 20)
        tableView.register(NodeCell.self, forCellReuseIdentifier: "ASYNC")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ASYNC", for: indexPath) as! NodeCell
//        cell.asyncImageView.image = UIImage(named: "font")
//        cell.asyncImageView2.image = UIImage(named: "taylor")
//        cell.asyncImageView3.image = UIImage(named: "root")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = SGUpdateViewController()
            vc.playLoopTimes = -1
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        if indexPath.row == 20 {
            dismiss(animated: true)
        }
    }

}

fileprivate class AsyncCell: UITableViewCell {
    
    lazy var myImageView: UIImageView = { UIImageView() }()
    lazy var myImageView2: UIImageView = { UIImageView() }()
    lazy var myImageView3: UIImageView = { UIImageView() }()
    
    lazy var asyncImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.image = UIImage(named: "font")
        return imageView
    }()
    lazy var asyncImageView2: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.image = UIImage(named: "taylor")
        return imageView
    }()
    lazy var asyncImageView3: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.image = UIImage(named: "root")
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

//        self.contentView.addSubview(myImageView)
//        self.contentView.addSubview(myImageView2)
//        self.contentView.addSubview(myImageView3)
//        myImageView.frame = CGRect(x: 20, y: 5, width: 90, height: 90)
//        myImageView2.frame = CGRect(x: myImageView.frame.maxX + 20, y: 5, width: 90, height: 90)
//        myImageView3.frame = CGRect(x: myImageView2.frame.maxX + 20, y: 5, width: 180, height: 90)
        
        self.contentView.addSubview(asyncImageView)
        self.contentView.addSubview(asyncImageView2)
        self.contentView.addSubview(asyncImageView3)
        asyncImageView.frame = CGRect(x: 20, y: 5, width: 90, height: 90)
        asyncImageView2.frame = CGRect(x: asyncImageView.frame.maxX + 20, y: 5, width: 90, height: 90)
        asyncImageView3.frame = CGRect(x: asyncImageView2.frame.maxX + 20, y: 5, width: 180, height: 90)
    }
    
}

class NodeCell: UITableViewCell {
    
    lazy var nodeView: NodeRootView = {
        let view = NodeRootView()
        view.frame = CGRect(x: 0, y: 100, width: kSCREEN_WIDTH, height: 100)
        return view
    }()
    
    lazy var nodeLabel: NodeLabel = {
        let label = NodeLabel()
        label.text = "Node Label"
        label.frame = CGRect(x: 118, y: 10, width: 100, height: 20)
        return label
    }()
    
    lazy var nodeTitle: NodeLabel = {
        let label = NodeLabel()
        label.text = "Taylor Swift - <1989> land to Music."
        label.frame = CGRect(x: 118, y: 100 - 10 - 20, width: 200, height: 20)
        return label
    }()
    
    lazy var nodeImageView: NodeImageView = {
        let imageView = NodeImageView()
        imageView.frame = CGRect(x: 10, y: 10, width: 80, height: 80)
        imageView.contents = UIImage(named: "taylor")
        imageView.setOnClickListener {
            Log.debug("click node imageView")
        }
        return imageView
    }()
    
    lazy var nodeButton: NodeButton = {
        let button = NodeButton()
        button.text = "Buy"
        button.backgroundColor = .orange
        button.textColor = .white
        button.frame = CGRect(x: kSCREEN_WIDTH - 60, y: 65, width: 40, height: 19)
        button.setOnClickListener {
            Log.debug("Buy")
        }
        return button
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.addSubview(nodeView)
        self.nodeView.addSubNode(nodeLabel)
        self.nodeView.addSubNode(nodeImageView)
        self.nodeView.addSubNode(nodeTitle)
        self.nodeView.addSubNode(nodeButton)
    }
    
}
