import RPi.GPIO as GPIO
import serial
from RPLCD.i2c import CharLCD
import re
import paho.mqtt.client as mqtt


# lcd
lcd = CharLCD('PCF8574', 0x27)
lcd.backlight_enabled = True

# serial
uart = serial.Serial('/dev/ttyAMA0', 9600)

# ------------------- mqtt 메소드 -------------------

# mqtt 접속
def on_connect(client, userdata, flags, rc):
    print("rc: " + str(rc))
 
# 브로커에게 메시지 도착시 실행 
def on_message(client, obj, msg):
    print(msg.topic + " " + str(msg.qos) + " " + str(msg.payload))
 
# publish 성공시 실행: publish를 보내고 난 후 처리를 하고 싶을 때 사용
def on_publish(client, obj, mid):
    print("mid: " + str(mid))
 
# subscribe 성공시 호출
def on_subscribe(client, obj, mid, granted_qos):
    print("Subscribe complete : " + str(mid) + " " + str(granted_qos))

# 객체 할당
mqttc = mqtt.Client()

# 콜백 함수 할당하기
mqttc.on_message = on_message
mqttc.on_connect = on_connect
mqttc.on_publish = on_publish
mqttc.on_subscribe = on_subscribe

# mqtt 접속시 필요한 정보
url = "cloudMQTT에서 제공한 링크"
port = 11111
username = "username"
password = "password"

mqttc.username_pw_set(username, password)
mqttc.connect(url ,port)

# 사용 토픽 구독
mqttc.subscribe("temp",0)
mqttc.subscribe("humi",0)

mqttc.loop()

	
while True:
	temp = uart.readline()
	humi = uart.readline()
	t = re.sub(r'[^0-9]', '', str(temp))
	h = re.sub(r'[^0-9]', '', str(humi))
	
	print(t)
	print(h)
	
	lcd.clear() 
	lcd.write_string('temp:')
	lcd.write_string(t)
	
	lcd.cursor_pos = (1,0)
	lcd.write_string('humi:')
	lcd.write_string(h)
	
	
	# ------------ mqtt publish ------------
	mqttc.publish("temp", t)
	mqttc.publish("humi",h)
