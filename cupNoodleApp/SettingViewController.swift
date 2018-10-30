//
//  SettingViewController.swift
//  cupNoodleApp
//
//  Created by 篠原立樹 on 2018/10/27.
//  Copyright © 2018 Ostrich. All rights reserved.
//

import UIKit
import AVFoundation

class SettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //UIPickerViewに表示するデータをArrayで作成
//    let settingArray : [Int] = [240, 180, 150, 120, 90, 60, 30, 15, 3]
    let settingArray : [String] = ["やわらかめ", "普通", "硬め", "バリカタ", "ハリガネ", "粉落とし", "湯気通し", "なま"]
    
    //設定値を覚えるキーを設定
    let settingKey = "timer_value"
    let settingKey2 = "title_value"
    
    //再生するサウンドのインスタンスを作成
    var audioDecision : AVAudioPlayer! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //timerSettingPickerのデリゲートとデータソースの通知先を指定
        timerSettingPicker.delegate = self
        timerSettingPicker.dataSource = self
        
        //UserDefaultsの取得
        let settingTitle = UserDefaults.standard
        let titleValue = settingTitle.string(forKey: settingKey2)
        
        //Pickerの選択を合わせる
            switch titleValue{
            case "やわらかめ":
                timerSettingPicker.selectRow(0, inComponent: 0, animated: true)
            case "普通":
                timerSettingPicker.selectRow(1, inComponent: 0, animated: true)
            case "硬め":
                timerSettingPicker.selectRow(2, inComponent: 0, animated: true)
            case "バリカタ":
                timerSettingPicker.selectRow(3, inComponent: 0, animated: true)
            case "ハリガネ":
                timerSettingPicker.selectRow(4, inComponent: 0, animated: true)
            case "粉落とし":
                timerSettingPicker.selectRow(5, inComponent: 0, animated: true)
            case "湯気通し":
                timerSettingPicker.selectRow(6, inComponent: 0, animated: true)
            case "なま":
                timerSettingPicker.selectRow(7, inComponent: 0, animated: true)
            default:print("エラー")
            }
        
        //サウンドファイルのパスを作成
        let soundFilePathDecision = Bundle.main.path(forResource: "decision", ofType: "mp3")!
        let soundDecision:URL = URL(fileURLWithPath: soundFilePathDecision)
        
        //AVAudioPlayerのインスタンスを作成、ファイルの読み込み
        do {
            audioDecision = try AVAudioPlayer(contentsOf: soundDecision, fileTypeHint: nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        
        //再生の準備をする
        audioDecision.prepareToPlay()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var timerSettingPicker: UIPickerView!
    
    @IBAction func dicisionButtonAction(_ sender: Any) {
        
        //連打した時に連続して音がなるように設定
        audioDecision.currentTime = 0 //再生場所を0に戻す
        audioDecision.play()
        
        //前の画面に戻る
        _ = navigationController?.popViewController(animated: true)
    }
    
    //UIPickerViewの列数を設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    //UIPickerViewの行数を取得
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return settingArray.count
        
    }
    
    //UIPickerViewの表示する内容を設定
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return String(settingArray[row])
        
    }
    
    //picker選択時に実行
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //UserDefaultsの設定
        let settings = UserDefaults.standard
        let settingTitle = UserDefaults.standard

        switch settingArray[row]{
            case "やわらかめ":
                settings.setValue("240", forKey: settingKey)
                settingTitle.setValue("やわらかめ", forKey: settingKey2)
            case "普通":
                settings.setValue("180", forKey: settingKey)
                settingTitle.setValue("普通", forKey: settingKey2)
            case "硬め":
                settings.setValue("150", forKey: settingKey)
                settingTitle.setValue("硬め", forKey: settingKey2)
            case "バリカタ":
                settings.setValue("120", forKey: settingKey)
                settingTitle.setValue("バリカタ", forKey: settingKey2)
            case "ハリガネ":
                settings.setValue("90", forKey: settingKey)
                settingTitle.setValue("ハリガネ", forKey: settingKey2)
            case "粉落とし":
                settings.setValue("60", forKey: settingKey)
                settingTitle.setValue("粉落とし", forKey: settingKey2)
            case "湯気通し":
                settings.setValue("30", forKey: settingKey)
                settingTitle.setValue("湯気通し", forKey: settingKey2)
            case "なま":
                settings.setValue("3", forKey: settingKey)
                settingTitle.setValue("なま", forKey: settingKey2)
        default:print("エラー")
        }
        
        settings.synchronize()//データを「即時に」永続化
        settingTitle.synchronize()
    }
    
}
