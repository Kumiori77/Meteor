//
//  ViewController.swift
//  Meteor
//
//  Created by 이재언 on 2023/02/04.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - 프로퍼티
    
    // 좌우 버튼
    var left: UIButton! = UIButton(type: .custom)
    var right: UIButton! = UIButton(type: .custom)
    
    // 플레이어
    var player: UIImageView! = UIImageView(image: UIImage(named: "player"))
    
    // 운석 뷰
    var meteor: UIImageView!
    
    // 운석 카운트
    var meteorCnt: Int = 0
    
    // 운석 카운트 레이블
    var meteorCountLabel: UILabel!
    
    // 시간 표시 레이블
    var timelabel: UILabel!
    
    // 경과 시간
    var time: Int = 0
    
    // 타이머
    var timer: Timer!
    
    // 게임 설명 이미지
    var explaining: UIImageView!
    
    // 게임 시작 버튼
    var startButton: UIButton!
    
    // 팝업 화면
    var popUp: UIImageView!
    
    // 리스타트 버튼
    var restartButton: UIButton!
    
    // 기록 표시 레이블
    var recordLabel: UILabel!
    
    // 플레이 시간 표시 레이블
    var playTimeLabel: UILabel!
    
    
    // MARK: 메소드

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 앱 초기화면 설정 메소드
        initApp()
        
    }
    
    // 시작화면 메소드
    func initApp() {
        
        // 백그라운드 이미지
        let background = UIImageView(image: UIImage(named: "background"))
        background.frame = CGRect(x: -1, y: -1, width: 392, height: 846)
        view.addSubview(background)

        // 화살표 버튼
        left.setImage(UIImage(named: "left"), for: .normal)
        left.setImage(UIImage(named: "highlightedLeft"), for: .highlighted)
        left.frame = CGRect(x: 25, y: 719, width: 100, height: 100)
        view.addSubview(left)

        right.setImage(UIImage(named: "right"), for: .normal)
        right.setImage(UIImage(named: "highlightedRight"), for: .highlighted)
        right.frame = CGRect(x: 265, y: 719, width: 100, height: 100)
        view.addSubview(right)

        // 플레이어
        player.frame = CGRect(x: 161.5, y: 594, width: 67, height: 100)
        view.addSubview(player)
        
        // 시간 표시 레이블
        timelabel = UILabel(frame: CGRect(x: 250, y: 50, width: 150, height: 30))
        timelabel.text = "00:00:00"
        timelabel.textColor = UIColor.white
        timelabel.font = UIFont.boldSystemFont(ofSize: 30)
        view.addSubview(timelabel)
        
        // 운석 카운트 레이블
        meteorCountLabel = UILabel(frame: CGRect(x: 20, y: 50, width: 70, height: 30))
        meteorCountLabel.text = "0"
        meteorCountLabel.textColor = UIColor.white
        meteorCountLabel.font = UIFont.boldSystemFont(ofSize: 30)
        view.addSubview(meteorCountLabel)
        
        // 운석 세팅 메소드 호출
        setMeteor()
        
        // 설명 이미지
        explaining = UIImageView(image: UIImage(named: "explaining"))
        explaining.frame = CGRect(x: 5, y: 240, width: 380, height: 320)
        view.addSubview(explaining)
        
        // 시작 버튼
        startButton = UIButton(type: .custom)
        startButton.setImage(UIImage(named: "start"), for: .normal)
        startButton.setImage(UIImage(named: "highlightedStart"), for: .highlighted)
        startButton.frame = CGRect(x: 145, y: 467, width: 100, height: 67)
        // 메소드 연결
        startButton.addTarget(self, action: #selector(starting), for: .touchUpInside)
        view.addSubview(startButton)
        
    }
    
    // 운석 세팅 메소드
    func setMeteor() {
        // 운석 이름 배열
        let meteorImgs: [String] = ["meteor1", "meteor2"]
        
        // 운석 이미지 설정
        meteor = UIImageView(image: UIImage(named: meteorImgs[meteorCnt % 2]))
        
        // 운성 생성 위치를 랜덤으로 하기
        let x = Float.random(in: 0.0...310.0)
        
        meteor.frame = CGRect(x: Int(x), y: -160, width: 80, height: 80)
        view.addSubview(meteor)
    }
    
    // 화면 안에 머무르게 하는 메소드
    func stayInScreen(_ x: Float, _ width: Float) -> Float {
        if x < 0 {
            return 0
        }
        else if x > (390.0 - width) {
            return (390.0 - width)
        }
        else {
            return x
        }
    }
    
    
    // 시작 버튼 메소드
    @objc func starting() {
        // 게임 설명 이미지와 게임 시작 버튼 지우기
        startButton.removeFromSuperview()
        explaining.removeFromSuperview()
        
        // 게임 시작 메소드 호출
        gameStart()
    }
    
    // 게임 시작 메소드
    func gameStart() {
        
        // 타이머 생성
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {
            [unowned self] (timer: Timer) in
            // 게임 경과 시간 화면에 표시 메소드 호출
            elapsedTime()
            
            // 운석 내리는 메소드 호출
            downMeteor()
            
            // 플레이어 움직이는 메소드 호출
            movePlayer()
            
            // 충돌 감지하는 메소드 호출
            if collider() {
                // 충돌했다면
                
                // 타이머 정지
                timer.invalidate()
                // 게임 종료 메소드 호출
                gameOver()
            }
        })
    }
    
    // 경과 시간을 표시하는 메소드
    func elapsedTime() {
        // 시간 1 증가
        time += 1
        
        // 분, 초, 밀리초로 구분
        let min: Int = Int(time / 6000)
        let sec: Int = Int((time % 6000) / 100)
        let mil: Int = Int(time % 100)
        
        // 경과 시간 화면에 표시
        self.timelabel.text = String(format: "%02ld:%02ld:%02ld", min, sec, mil)
        
    }
    
    // 운석 내리는 메소드
    func downMeteor() {
        // 운석의 y좌표 변경 (시간에 따라 속도 증가
        self.meteor.frame.origin.y += CGFloat(speedUp())
        
        // 운석과 지면의 충돌 확인
        if self.meteor.frame.origin.y >= CGFloat(614) {
            // 운석 제거
            meteor.removeFromSuperview()
            // 운석 카운트 증가
            meteorCnt+=1
            meteorCountLabel.text = String(meteorCnt)
            // 운석 세팅
            setMeteor()
        }
    }
    
    // 시간에 따라 운석의 속도를 높이는 메소드
    func speedUp() -> Double {
        // 운석의 속도
        let speed: Double = 7 + Double(time / 900)
        
        return speed
    }
    
    // 플레이어 움직이는 메소드
    func movePlayer() {
        // 플레이어가 이동할 좌표
        var moveTo = player.frame.origin.x
        // 왼쪽 버튼만 눌린 경우
        if self.left.isHighlighted && !self.right.isHighlighted {
            moveTo -= 6
        }
        // 오른쪽 버튼만 눌린 경우
        else if !self.left.isHighlighted && self.right.isHighlighted {
            moveTo += 6
        }
        
        // 플레이어가 화면을 나가지 않게 하기
        moveTo = CGFloat(stayInScreen(Float(moveTo), Float(player.frame.size.width)))
        self.player.frame.origin.x = moveTo
    }
    
    // 충돌 감지 메소드
    func collider() -> Bool {
        // 감지 포인트
        let points: [[Float]] = [[0, 23], [22, 0], [53, 0], [67, 23]]
        
        // 각각의 포인트와 운석과의 거리 계산
        for point in points {
            let playerX = Float(self.player.frame.origin.x) + point[0]
            let playerY = Float(self.player.frame.origin.y) + point[1]
            let meteorX = Float(self.meteor.frame.origin.x) + 40
            let meteorY = Float(self.meteor.frame.origin.y) + 40
            
            let a = playerX - meteorX
            let b = playerY - meteorY
            let c = (a*a) + (b*b)
            
            // 충돌했다면 true 반환
            if c <= 1600 {
                return true
            }
        }
        // 충돌하지 않으면 false 반환
        return false
    }
    
    // 게임 종료 메소드
    func gameOver() {
        
        // 팝업 화면 띄우기
        popUp = UIImageView(image: UIImage(named: "popUp"))
        popUp.frame = CGRect(x: 5, y: 240, width: 380, height: 320)
        view.addSubview(popUp)
        
        // 리스타트 버튼 띄우기
        restartButton = UIButton(type: .custom)
        restartButton.setImage(UIImage(named: "restart"), for: .normal)
        restartButton.setImage(UIImage(named: "highlightedRestart"), for: .highlighted)
        restartButton.frame = CGRect(x: 145, y: 475, width: 100, height: 67)
        // 이미지와 버튼 크기가 동일하게 지정
        restartButton.contentMode = . scaleAspectFit
        // 버튼에 메소드 연결
        restartButton.addTarget(self, action: #selector(gameRestart), for: .touchUpInside)
        view.addSubview(restartButton)
        
        // 기록 표시
        recordLabel = UILabel(frame: CGRect(x: 172, y: 357, width: 100, height: 30))
        recordLabel.text = String(meteorCnt)
        recordLabel.textColor = UIColor.white
        recordLabel.font = UIFont.boldSystemFont(ofSize: 30)
        view.addSubview(recordLabel)
        
        // 플레이타임 표시
        playTimeLabel = UILabel(frame: CGRect(x: 172, y: 413, width: 150, height: 30))
        playTimeLabel.text = timelabel.text
        playTimeLabel.textColor = UIColor.white
        playTimeLabel.font = UIFont.boldSystemFont(ofSize: 30)
        view.addSubview(playTimeLabel)
        
        // 플레이어 이미지 변경
        player.image = UIImage(named: "deadPlayer")
        
    }
    
    // 게임 제시작 메소드
    @objc func gameRestart() {
        
        // 운석, 팝업창, 리스타트 버튼 제거
        meteor.removeFromSuperview()
        popUp.removeFromSuperview()
        restartButton.removeFromSuperview()
        recordLabel.removeFromSuperview()
        playTimeLabel.removeFromSuperview()
        
        // 기록 & 플레이 타임 초기화
        meteorCnt = 0
        time = 0
        meteorCountLabel.text = String(meteorCnt)
        timelabel.text = "00:00:00"
        
        // 플레이어 이미지 & 위치 초기화
        player.image = UIImage(named: "player")
        player.frame.origin.x = 161.5
        
        // 운석 세팅 메소드 호출
        setMeteor()
        
        // 게임 시작 메소드호출
        gameStart()
    }


}

