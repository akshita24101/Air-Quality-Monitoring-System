# Air-Quality-Monitoring-System
A real-time indoor air monitoring system built using Arduino. It measures temperature, humidity, and air quality using DHT11 and MQ-135 sensors. The system displays the values on an LCD screen and uses an LED to indicate air quality levels. An IR remote allows switching between display modes for better usability.  

## 📌 Features
- Monitors temperature, humidity, and air quality in real-time
- LCD display for live feedback
- IR remote control for toggling display modes
- LED indication based on air quality:
  - **Good** (<200): slow blinking
  - **Moderate** (200–300): fast blinking
  - **Poor** (>300): always ON

## 🧰 Components Used
- Arduino Uno
- DHT11 Sensor (Temperature & Humidity)
- Grove Air Quality Sensor v1.3 (MQ-135)
- 16x2 LCD (non-I2C)
- IR Receiver + IR Remote
- LED
- Breadboard, jumper wires, resistors
- USB power supply

## ⚙️ Working
- DHT11 provides digital temperature and humidity data.
- MQ-135 outputs are used to determine air quality levels.
- Arduino processes sensor data and displays it on the LCD.
- LED blinks based on gas concentration level.
- IR remote allows switching between different data views (temperature, humidity, air quality, or all combined).

## 🚀 Future Scope
- Wi-Fi integration using ESP8266/ESP32 for remote monitoring
- Data logging via SD card or cloud
- Integration with Alexa or Google Assistant
- OLED or touchscreen upgrade
- Portable version using rechargeable batteries

## 📝 License
This project is open-source and free to use under the MIT License.

## 🙋‍♀️ Author
**Akshita Sondhi**  
Student (ECE), IIIT-Naya Raipur  
Enthusiastic about electronics, AI, and real-world applications of technology.

