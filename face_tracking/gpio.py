import RPi.GPIO as GPIO
import time


#Initialisation
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

#Declare pin numbers
pin4 = 4
pin3 = 3
pin2 = 2

#Set up the pins as output
GPIO.setup(pin2, GPIO.OUT)
GPIO.setup(pin3, GPIO.OUT)
GPIO.setup(pin4, GPIO.OUT)

#Set starting value to 0
integer = 0
#Infinite loop
while True:
	outputBi(Dec2Bi(integer)) #Convert integer to binary and send it through to the DE2
	integer = integer + 1     #Increment integer variable
	if integer >= 8:          #If integer is 8 or bigger (greater than 3 bits, set integer to 0
		integer = 0
GPIO.cleanup()                    #Resets pins to be useable after the program ends. Code will never reach this point, but was recommended online


#Decimal to integer converter (3 bits)
def Dec2Bi(integer):
	return >>> bin(integer) [2:]

#Outputs a binary value to the DE2
def outputBi(value):
	value0 = (value >> 2) & 0b001
	value1 = (value >> 1) & 0b001
	value2 = value & 0b001

	
	GPIO.output(pin4, value0)
	GPIO.output(pin3, value1)
	GPIO.output(pin2, value2)
	time.sleep(1)
	return
