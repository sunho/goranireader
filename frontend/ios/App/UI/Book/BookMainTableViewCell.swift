//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import UIKit

enum ContentStatus {
    case local
    case remote
}

class BookMainTableViewCell: BookListTableViewCell {
    var status: ContentStatus = .local {
        didSet {
            if status != oldValue {
                self.layout()
            }
        }
    }
    
    var progress: Float = 0 {
        didSet {
            if progress != oldValue {
                layout()
            }
        }
    }
    
    var downloadView: UIImageView!
    var progressView: CircleBarView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        progressView = CircleBarView(frame: CGRect())
        container.addSubview(progressView)
        progressView.snp.makeConstraints { make -> Void in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.left.equalTo(nameView.snp.right).offset(4)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        downloadView = UIImageView(image: UIImage(named: "download_btn"))
        container.addSubview(downloadView)
        downloadView.snp.makeConstraints{ make -> Void in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    override func layout() {
        super.layout()
        switch status {
        case .remote:
            if progress == 0 {
                downloadView.isHidden = false
                progressView.isHidden = true
            } else {
                downloadView.isHidden = true
                progressView.isHidden = false
                progressView.progressColor = Color.gray
                progressView.value = progress
            }
        case .local:
            downloadView.isHidden = true
            progressView.isHidden = false
            progressView.progressColor = Color.tint
            if progress == 0 {
                progressView.value = 0
            } else {
                progressView.value = progress
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
