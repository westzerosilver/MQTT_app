//
//  ViewController.swift
//  raspberry_mqtt
//
//  Created by yeseo on 2023/08/18.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController {
   
    // 라벨 변수
    @IBOutlet weak var label_temp: UILabel!             // 온도 라벨 변수
    @IBOutlet weak var label_humi: UILabel!             // 습도 라벨 변수
    var mqtt: CocoaMQTT!                                // mqtt 객체 변수
    let user = "username"                               // client ID
    var timer = Timer()                                 // 타이머 관련 변수

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 30초마다 함수 실행
        timer = Timer.scheduledTimer(timeInterval: 30, target: self,
                selector: #selector(setUpMQTT), userInfo: nil, repeats: true)
        
    }
    
    // MQTT 브로커에 연결할 클라이언트 생성
    @objc func setUpMQTT() {
        mqtt = CocoaMQTT(clientID: user, host: "cloudmqttURL", port: 11111)
        mqtt!.logLevel = .debug
        mqtt!.username = user
        mqtt!.password = "password"
        mqtt!.keepAlive = 10
        mqtt.connect()
        mqtt!.delegate = self
    }
    
}

// CocoaMQTTDelegate 설정
extension ViewController: CocoaMQTTDelegate {

    // self signed delegate
    func mqttUrlSession(_ mqtt: CocoaMQTT, didReceiveTrust trust: SecTrust, didReceiveChallenge challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        
        debugPrint("mqttUrlSession")

    }


    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        debugPrint("ack: \(ack)")
        
        // 연결 성공시 토픽 구독
        if ack == .accept {
            mqtt.subscribe("temp")
            mqtt.subscribe("humi")
            
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        debugPrint("new state: \(state)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        debugPrint("message: \(message.string?.description), id: \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        debugPrint("id: \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        debugPrint("message: \(message.string?.description), id: \(id)")

        let name = NSNotification.Name(rawValue: "MQTTMessageNotification" + user)
        NotificationCenter.default.post(name: name, object: self, userInfo: ["message": message.string!, "topic": message.topic, "id": id])
        
        // 온도 습도 라벨 설정.
        if (message.topic == "temp") {
            self.label_temp.text = message.string!
        }
        else if (message.topic == "humi") {
            self.label_humi.text = message.string!
        }
        
    }

    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        debugPrint("subscribed: \(success), failed: \(failed)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        debugPrint("topic: \(topics)")
    }

    func mqttDidPing(_ mqtt: CocoaMQTT) {
        //TRACE()
    }

    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        //TRACE()
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        debugPrint("\(err.debugDescription)")
    }
}


