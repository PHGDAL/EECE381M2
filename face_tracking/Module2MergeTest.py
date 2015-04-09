from multiprocessing import Process, Queue
import RPi.GPIO as GPIO
import time
import cv2


# Sends coordinates X and Y to the DE2 using our communication protocol
def outputDE2(coordx, coordy):

	# Separate the 8 bits of X coordinate
	# coordx0 is the least significant bit while coordx7 is the most significant bit
	coordx0 = value & 0b00000001
	coordx1 = ((value) >> 1) & 0b00000001
	coordx2 = ((value) >> 2) & 0b00000001
	coordx3 = ((value) >> 3) & 0b00000001
	coordx4 = ((value) >> 4) & 0b00000001
	coordx5 = ((value) >> 5) & 0b00000001
	coordx6 = ((value) >> 6) & 0b00000001
	coordx7 = ((value) >> 7) & 0b00000001

	# Separate the 8 bits of Y coordinate
	# coordy0 is the least significant bit while coordy7 is the most significant bit
	coordy0 = value & 0b00000001
	coordy1 = ((value) >> 1) & 0b00000001
	coordy2 = ((value) >> 2) & 0b00000001
	coordy3 = ((value) >> 3) & 0b00000001
	coordy4 = ((value) >> 4) & 0b00000001
	coordy5 = ((value) >> 5) & 0b00000001
	coordy6 = ((value) >> 6) & 0b00000001
	coordy7 = ((value) >> 7) & 0b00000001
	
	# Latch X and Y bits into DE2 shift register in order least -> most significant
	latch(coordx0, coordy0)
	latch(coordx1, coordy1)
	latch(coordx2, coordy2)
	latch(coordx3, coordy3)
	latch(coordx4, coordy4)
	latch(coordx5, coordy5)
	latch(coordx6, coordy6)
	latch(coordx7, coordy7)

	# Inform DE2 that the 8-bit coordinates have been latched
	GPIO.output(pinReady, 1)
	GPIO.output(pinReady, 0)

	return


# Latches the coordinates to the DE2's custom shift register
def latch(x, y):

	# Set pinX and pinY
	GPIO.output(pinX, x)
	GPIO.output(pinY, y)

	# Clock the latch
	GPIO.output(pinLatch, 1)
	GPIO.output(pinLatch, 0)

	return


# Initialisation code for webcam functionality
def InitialiseWebcam():

	# Get ready to start getting images from the webcam
	webcam = cv2.VideoCapture(0)
	webcam.set(cv2.cv.CV_CAP_PROP_FRAME_WIDTH, 320)
	webcam.set(cv2.cv.CV_CAP_PROP_FRAME_HEIGHT, 240)

	return


# Initialisation code for facetracking functionality
def InitialiseFaceTracking():
	
	# Frontal face pattern detection
	frontalface = cv2.CascadeClassifier("haarcascade_frontalface_alt2.xml")

	# Side face pattern detection
	profileface = cv2.CascadeClassifier("haarcascade_profileface.xml")
	
	# Default face values
	face = [0,0,0,0]
	Cface = [0,0]
	lastface = 0

	return


# Initialisation code for GPIO pin functionality
def InitialiseGPIO():

	#Pin mode settings
	GPIO.setmode(GPIO.BCM)
	GPIO.setwarnings(False)
	
	#Declare pin numbers
	pinX = 4
	pinY = 3
	pinReady = 2
	pinLatch = 5
	
	#Set up the pins as output
	GPIO.setup(pinX, GPIO.OUT)
	GPIO.setup(pinY, GPIO.OUT)
	GPIO.setup(pinReady, GPIO.OUT)
	GPIO.setup(pinLatch, GPIO.OUT)

	return


# Calls all initialisation functions in the correct order
def Initialise():

	InitialiseWebcam()
	InitialiseFaceTracking()
	InitialiseGPIO()

	return


# Main function allows this file to be imported and other functions used without necessarily running facetracking
if __name__ == "__main__":
	
	# Call initialisation functions
	Initialise()
	
	# Infinite loop begin
	while True:
		faceFound = False #Constantly look for a face
				
		# Find face technique 1 - Frontal face - (retries this method if the last face was found with this method)
		if not faceFound:
			if lastface == 0 or lastface == 1:
				aframe = webcam.read()[1]  # Captures frame
				cv2.imshow("Video",aframe) # Display the frame to us
				cv2.waitKey(1)             # Wait after displaying the frame, required for displaying to work
				fface = frontalface.detectMultiScale(aframe,1.3,4,(cv2.cv.CV_HAAR_DO_CANNY_PRUNING + cv2.cv.CV_HAAR_FIND_BIGGEST_OBJECT + cv2.cv.CV_HAAR_DO_ROUGH_SEARCH),(60,60))
				if fface != ():
					lastface = 1
					for f in fface:
						faceFound = True
						face = f

		# Find face technique 2 - Side Face Right- (retries this method if the last face was found with this method)
		if not faceFound:
			if lastface == 0 or lastface == 2:
				aframe = webcam.read()[1]  # Captures frame
				cv2.imshow("Video",aframe) # Display the frame to us
				cv2.waitKey(1)             # Wait after displaying the frame, required for displaying to work
				pfacer = profileface.detectMultiScale(aframe,1.3,4,(cv2.cv.CV_HAAR_DO_CANNY_PRUNING + cv2.cv.CV_HAAR_FIND_BIGGEST_OBJECT + cv2.cv.CV_HAAR_DO_ROUGH_SEARCH),(80,80))
				if pfacer != ():
					lastface = 2
					for f in pfacer:
						faceFound = True
						face = f

		#Find face technique 3 - Side Face Left - (retries this method if the last face was found with this method)
			if not faceFound:
			if lastface == 0 or lastface == 3:
				aframe = webcam.read()[1]  # Captures frame
				cv2.imshow("Video",aframe) # Display the frame to us
				cv2.waitKey(1)             # Wait after displaying frame, required for displaying to work
				cv2.flip(aframe,1,aframe)  # Flip image to try searching for a face in reverse
				pfacel = profileface.detectMultiScale(aframe,1.3,4,(cv2.cv.CV_HAAR_DO_CANNY_PRUNING + cv2.cv.CV_HAAR_FIND_BIGGEST_OBJECT + cv2.cv.CV_HAAR_DO_ROUGH_SEARCH),(80,80))
				if pfacel != ():
					lastface = 3
					for f in pfacel:
						faceFound = True
						face = f
		
		if not faceFound:
			lastface = 0
			face = [0,0,0,0]
		
		# Get coordinates of face
		x,y,w,h = face
		Cface = [(w/2+x),(h/2+y)]
		print str(Cface[0]) + "," + str(Cface[1]) # Display face coordinates on the console
		
		# Send coordinates to the DE2 for servo processing
		outputDE2(Cface[0], Cface[1])

	GPIO.cleanup() # Resets pins to be useable after program termination

	

