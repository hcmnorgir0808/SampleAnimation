//
//  Animation2ViewController.swift
//  SampleAnimation
//
//  Created by sakiyamaK on 2020/07/31.
//  Copyright © 2020 sakiyamaK. All rights reserved.
//

import UIKit

final class HalfModalViewController: UIViewController {

    @IBOutlet private weak var slideViewCenterYConstraint: NSLayoutConstraint!
    
    //オマケ 一応見栄え良く角丸にしてるだけ
    @IBOutlet private weak var topBarView: UIView! {
        didSet {
            topBarView.layer.cornerRadius = topBarView.frame.size.height/2
            topBarView.clipsToBounds = true
        }
    }
    
    @IBOutlet private weak var slideView: UIView! {
        didSet {
            //全体をタッチしたらタップアクションを実行させる
            let t = UITapGestureRecognizer.init(target: self, action: #selector(tapSlideView))
            slideView.addGestureRecognizer(t)
        }
    }
    
    @IBOutlet private weak var mainView: UIView!
    
    @IBOutlet private weak var halfMainViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDefaultPosition()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(drag(gesture:)))
        mainView.addGestureRecognizer(panGesture)
    }
    
    @objc func drag(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            // 移動量を取得
            let point = gesture.translation(in: mainView)
            // 今のx, y座標のcenterに移動量のx, yを加算 or 減算
            let pointMinY = max(self.view.frame.minY, mainView.frame.minY + point.y)
            let pointMaxY = min(self.view.frame.maxY, mainView.frame.maxY + point.y)
            
            let pointY = (pointMinY + pointMaxY) / 2
            let movedPoint = CGPoint(x: mainView.center.x, y: pointY)
            
            mainView.center = movedPoint
            
            halfMainViewHeightConstraint.constant -= point.y
            
            gesture.setTranslation(.zero, in: mainView)
        case .ended:
            if halfMainViewHeightConstraint.constant <= self.view.frame.height / 2 {
                UIView.animate(withDuration: 0.15) {
                    self.halfMainViewHeightConstraint.constant = 200
                    self.view.layoutIfNeeded()
                }
            } else {
                UIView.animate(withDuration: 0.15) {
                    self.halfMainViewHeightConstraint.constant = self.view.frame.height * 0.9
                    self.view.layoutIfNeeded()
                }
            }
        default: break
        }
    }
    
    func dismissModal(isAnimation: Bool = true) {
        //制約のconstantをviewの高さ分にして画面外に移動させる
        slideViewCenterYConstraint.constant = self.view.frame.height/2
        
        if isAnimation {
            //制約をアニメーションさせながら更新
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
            }) { (_) in
                //アニメーションが終わったらこのview controller自体をdismiss
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            //アニメーションがないのでそのまま、このview controller自体をdismiss
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //モーダルを出現させる
    func showModal(isAnimation: Bool = true) {
        //制約のconstantを0にして画面中央に移動させる
        slideViewCenterYConstraint.constant = 0
        if isAnimation {
            //制約をアニメーションさせながら更新
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        } else {
            //アニメーションがないのでそのまま制約を更新
            self.view.layoutIfNeeded()
        }
    }
}

private extension HalfModalViewController {
    @IBAction func tapChijime(_ sender: Any) {
        chijime()
    }
    
    @IBAction func tapNobiro(_ sender: Any) {
        nobiro()
    }
    
    @objc func tapSlideView() {
        self.dismissModal(isAnimation: true)
    }
}

private extension HalfModalViewController{
    func setDefaultPosition() {
        /*制約のconstantをデフォルトにする*/
        
        // 隠す
        // ストーリーボードを改修するとわけわかんない状態になる
        slideViewCenterYConstraint.constant = self.view.frame.height/2
        halfMainViewHeightConstraint.constant = 300
        self.view.layoutIfNeeded()
    }
    
    func nobiro() {
        //制約のconstantを画面の高さ*0.8にする
        halfMainViewHeightConstraint.constant = self.view.frame.height
        //制約をアニメーションさせながら更新
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func chijime() {
        //制約のconstantを300にする
        halfMainViewHeightConstraint.constant = 300
        //制約をアニメーションさせながら更新
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

}
