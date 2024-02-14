## MQTT_app
MQTT를 이용해 iOS앱과 라즈베리파이가 통신합니다.

1. 아두이노(arduino_getTempAndHumi)
   - 온도, 습도 값 측정
   - 블루투스로 라즈베리파이에 온도, 습도 값 전달
    
2. 라즈베리파이(raspberry_python)
   - MQTT를 이용해 온도, 습도 데이터를 앱으로 전송(CloudMQTT 사용)

4. 앱(raspberrypi_app)
   - MQTT로 온도, 습도 값 받아옴
   - 화면에 온/습도 값 프린트
