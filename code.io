
#include <IRremote.hpp>
#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>
#include <LiquidCrystal.h>

// LCD pin config: RS, E, D4, D5, D6, D7
LiquidCrystal lcd(12, 11, 10, 9, 8, 7);
const int ledPin = 5;
const int IR_RECEIVE_PIN = 2; // IR receiver pin
int displayMode = 0; // 0 = All, 1 = Temp, 2 = Humidity, 3 = AQ

// DHT22 setup
#define DHTPIN 6
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

// Air quality sensor pin
const int airQualityPin = A0;

// Non-blocking LED blink variables
unsigned long previousMillis = 0;
int ledState = LOW;
int blinkInterval = 0;

void setup() {
  pinMode(ledPin, OUTPUT);
  IrReceiver.begin(IR_RECEIVE_PIN, ENABLE_LED_FEEDBACK);
  Serial.begin(9600);
  dht.begin();
  lcd.begin(16, 2);

  lcd.setCursor(0, 0);
  lcd.print("  Air Quality");
  lcd.setCursor(0, 1);
  lcd.print("    Monitor");
  delay(3000);
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Initializing...");
  delay(2000);
  lcd.clear();
}

void handleLED(int airValue) {
  static unsigned long lastBlinkTime = 0;
  static int blinkState = LOW;

  if (airValue <= 50) {
    digitalWrite(ledPin, HIGH);
  } else if (airValue > 50 && airValue <= 100) {
    unsigned long currentMillis = millis();
    if (currentMillis - lastBlinkTime >= 100) {
      lastBlinkTime = currentMillis;
      blinkState = !blinkState;
      digitalWrite(ledPin, blinkState);
    }
  } else {
    digitalWrite(ledPin, HIGH);
  }
}

void loop() {
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();
  int airValue = analogRead(airQualityPin);
  String airStatus;

  if (airValue <= 50) airStatus = "(Good)";
  else if (airValue <= 100) airStatus = "(Moderate)";
  else airStatus = "(Poor)";

  handleLED(airValue);

  if (isnan(temperature) || isnan(humidity)) {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Sensor Error");
    lcd.setCursor(0, 1);
    lcd.print("Check wiring");
    Serial.println("Failed to read from DHT22 sensor!");
    delay(1000);
    return;
  }

  if (IrReceiver.decode()) {
    switch (IrReceiver.decodedIRData.command) {
      case 0x16: displayMode = 0; break; // Button 0
      case 0x0C: displayMode = 1; break; // Button 1
      case 0x18: displayMode = 2; break; // Button 2
      case 0x5E: displayMode = 3; break; // Button 3
    }
    IrReceiver.resume();
  }

  lcd.clear();
  lcd.setCursor(0, 0);

  if (displayMode == 0) {
    lcd.print("T:"); lcd.print(temperature, 0); lcd.print("C H:");
    lcd.print(humidity, 0); lcd.print("%");
    lcd.setCursor(0, 1);
    lcd.print("AQ:"); lcd.print(airValue); lcd.print(" "); lcd.print(airStatus);
  } else if (displayMode == 1) {
    lcd.print("Temperature:");
    lcd.setCursor(0, 1);
    lcd.print(temperature, 1); lcd.print(" C");
  } else if (displayMode == 2) {
    lcd.print("Humidity:");
    lcd.setCursor(0, 1);
    lcd.print(humidity, 1); lcd.print(" %");
  } else if (displayMode == 3) {
    lcd.print("Air Quality:");
    lcd.setCursor(0, 1);
    lcd.print("AQ: "); lcd.print(airValue); lcd.print(" "); lcd.print(airStatus);
  }

  Serial.print("Temp: "); Serial.print(temperature); Serial.print(" C, ");
  Serial.print("Humidity: "); Serial.print(humidity); Serial.print(" %, ");
  Serial.print("Air Quality: "); Serial.println(airValue);

  delay(500);
}
