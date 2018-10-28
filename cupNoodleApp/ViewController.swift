//
//  ViewController.swift
//  cupNoodleApp
//
//  Created by 篠原立樹 on 2018/10/27.
//  Copyright © 2018 Ostrich. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //タイマーの変数を作成
    var timer : Timer!
    
    //カウント（経過時間）の変数を作成
    var count = 0
    
    //設定値を扱うキーを設定
    let settingKey = "timer_value"
    
    //再生するサウンドのインスタンス
    var audioStart : AVAudioPlayer! = nil
    var audioStop : AVAudioPlayer! = nil

    override func viewDidLoad() {//このViewControllerが呼び出される時に一度だけ実行される
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //UserDefaultsのインスタンスを作成
        let setting = UserDefaults.standard
        
        //UserDefaultsに初期値を登録
        setting.register(defaults: [settingKey:180])
        
        //サウンドファイルのパスを作成
        let soundFilePathStart = Bundle.main.path(forResource: "start", ofType: "mp3")!
        let soundStart:URL = URL(fileURLWithPath: soundFilePathStart)
        let soundFilePathStop = Bundle.main.path(forResource: "stop", ofType: "mp3")!
        let soundStop:URL = URL(fileURLWithPath: soundFilePathStop)
        
        //AVAudioPlayerのインスタンスを作成、ファイルの読み込み
        do {
            audioStart = try AVAudioPlayer(contentsOf: soundStart, fileTypeHint: nil)
            audioStop = try AVAudioPlayer(contentsOf: soundStop, fileTypeHint: nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        
        //再生の準備をする
        audioStart.prepareToPlay()
        audioStop.prepareToPlay()
        
    }

    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBAction func settingButtonAction(_ sender: Any) {//「麺の硬さ」がタップされたら実行
        
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            
            //タイマーが実行中だったら停止
            if nowTimer.isValid == true {
                
                //タイマー停止
                nowTimer.invalidate()
                
            }
        }
        
        //画面遷移を行う
        performSegue(withIdentifier: "goSetting",//segueで関連付けた画面を指定
                     sender: nil)//画面遷移時に渡すデータを指定
    }
    
    @IBAction func startButtonAction(_ sender: Any) {//スタートボタンがタップされたら実行
        
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            
            //もしタイマーが、実行中だったらスタートしない
            if nowTimer.isValid == true {
                
                //何もしないで終了
                return
                
            }
            
        }
        
        //連打した時に連続して音がなるように設定
        audioStart.currentTime = 0 //再生場所を0に戻す
        audioStart.play()
        
        //タイマーをスタート
        timer = Timer.scheduledTimer(timeInterval: 1.0,//タイマーを実行させる間隔。単位は秒
                                     target: self,//タイマー実行時の呼び出し先を指定
                                     selector: #selector(self.timerInterrupt(_:)),
                                     userInfo: nil,//設定したメソッドに渡す情報を指定
                                     repeats: true)//繰り返しを指定。false（一回のみ）
        
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {//ストップボタンがタップされたら実行
        
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            
            //もしタイマーが、実行中だったら中止
            if nowTimer.isValid == true {
                
                //連打した時に連続して音がなるように設定
                audioStop.currentTime = 0 //再生場所を0に戻す
                audioStop.play()
                
                //タイマーを停止
                nowTimer.invalidate()
                
            }
        }
        
        
    }
    
    
    func displayUpdate() -> Int {//画面の更新をする（戻り値：remainCount:残り時間）
        
        //UserDefaultsのインスタンスを作成
        let settings = UserDefaults.standard
        
        //取得した秒数をtimerValueに渡す
        let timerValue = settings.integer(forKey: settingKey)
        
        //残り時間（remainCount）を作成
        let remainCount = timerValue - count
        
        //remainCount（残りの時間）をラベルに表示
        countDownLabel.text = "残り\(remainCount)秒"
        
        //残り時間を戻り値に設定
        return remainCount
        
    }
    
    @objc func timerInterrupt(_ timer:Timer) {//スタートボタンがタップされたら呼び出される
        
        //count（経過時間）に+1していく
        count += 1
        
        //remainCount（残り時間）が0以下の時、タイマーを止める
        if displayUpdate() <= 0 {
            
            //初期化設定
            count = 0
            
            //タイマー停止
            timer.invalidate()
            
            //ダイアログを作成
            let alertController = UIAlertController(title: "完成",
                                                    message: "お好みの硬さにできました",
                                                    preferredStyle: .alert)//Alert or ActionSheet
            
            //ダイアログに表示させるOKボタンを作成
            let defaultAction = UIAlertAction(title: "OK",
                                              style: .default,
                                              handler: nil)
            
            //アクションを追加
            alertController.addAction(defaultAction)
            
            //ダイアログの表示
            present(alertController,
                    animated: true,
                    completion: nil)
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {//画面切り替えのタイミングで処理を行う
        
        //カウント（経過時間）をゼロにする
        count = 0
        
        //タイマーの表示を更新する
        _ = displayUpdate()
        
    }
    
}

