import cv2
#YOU NEED TO SPESIFCE EVERY SINGLE PATH OF VIDEO/IMAGE YOU ARE USING

face_cascade = cv2.CascadeClassifier('C:/Python/Python38/Lib/site-packages/cv2/data/haarcascade_frontalface_default.xml') 
#Cascade is to specify the cascade you will use to detect -or- the cascade of what you want to detect.

img = cv2.imread('C:/Users/mabfa/Desktop/pyt/faces-d.png') 
#This one is for image detection. Read the image

gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
#conver for gray image easer to process 

faces = face_cascade.detectMultiScale(gray, 2, 4)


for (x,y,w,h) in faces:
    cv2.rectangle(img, (x,y),(x+w, y+h), (255,0,0),2)

cv2.imshow('Image', img)
cv2.waitKey(0)    
cv2.destroyAllWindows()
