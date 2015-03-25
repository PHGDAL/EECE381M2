from multiprocessing import Process, Queue
import time
import cv2


webcam = cv2.VideoCapture(0)	# Get ready to start getting images from the webcam
webcam.set(cv2.cv.CV_CAP_PROP_FRAME_WIDTH, 320)
webcam.set(cv2.cv.CV_CAP_PROP_FRAME_HEIGHT, 240)

frontalface = cv2.CascadeClassifier("haarcascade_frontalface_alt2.xml")	# Frontal face pattern detection
profileface = cv2.CascadeClassifier("haarcascade_profileface.xml")	# Side face pattern detection

#Initialise
face = [0,0,0,0]
Cface = [0,0]
lastface = 0

#Infinite loop begin
while True:
	faceFound = False #Constantly look for a face
	
	
	#Find face technique 1 (retries this method if the last face was found with this method)
	if not faceFound:
		if lastface == 0 or lastface == 1:
			aframe = webcam.read()[1] #Captures frame
			cv2.imshow("Video",aframe) #Display the frame to us
			cv2.waitKey(1)             #Wait after displaying the frame, required for displaying to work
			fface = frontalface.detectMultiScale(aframe,1.3,4,(cv2.cv.CV_HAAR_DO_CANNY_PRUNING + cv2.cv.CV_HAAR_FIND_BIGGEST_OBJECT + cv2.cv.CV_HAAR_DO_ROUGH_SEARCH),(60,60))
			if fface != ():
				lastface = 1
				for f in fface:
					faceFound = True
					face = f
	#Find face technique 2 (retries this method if the last face was found with this method)
	if not faceFound:
		if lastface == 0 or lastface == 2:
			aframe = webcam.read()[1] #Captures frame
			cv2.imshow("Video",aframe) #Display the frame to us
			cv2.waitKey(1)             #Wait after displaying the frame, required for displaying to work
			pfacer = frontalface.detectMultiScale(aframe,1.3,4,(cv2.cv.CV_HAAR_DO_CANNY_PRUNING + cv2.cv.CV_HAAR_FIND_BIGGEST_OBJECT + cv2.cv.CV_HAAR_DO_ROUGH_SEARCH),(80,80))
			if pfacer != ():
				lastface = 2
				for f in pfacer:
					faceFound = True
					face = f
	#Find face technique 3 (retries this method if the last face was found with this method)
	if not faceFound:
		if lastface == 0 or lastface == 3:
			aframe = webcam.read()[1] #Captures frame
			
			cv2.imshow("Video",aframe) #Display the frame to us
			cv2.waitKey(1)             #Wait after displaying frame, required for displaying to work
			cv2.flip(aframe,1,aframe)  #Flip image to try searching for a face in reverse
			pfacel = frontalface.detectMultiScale(aframe,1.3,4,(cv2.cv.CV_HAAR_DO_CANNY_PRUNING + cv2.cv.CV_HAAR_FIND_BIGGEST_OBJECT + cv2.cv.CV_HAAR_DO_ROUGH_SEARCH),(80,80))
			if pfacel != ():
				lastface = 3
				for f in pfacel:
					faceFound = True
					face = f
	
	if not faceFound:
		lastface = 0
		face = [0,0,0,0]
	
	#Get coordinates of face
	x,y,w,h = face
	Cface = [(w/2+x),(h/2+y)]
	print str(Cface[0]) + "," + str(Cface[1]) #Display face coordinates

	
