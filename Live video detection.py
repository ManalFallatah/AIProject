import cv2


face_cascade = cv2.CascadeClassifier('C:/Python/Python38/Lib/site-packages/cv2/data/haarcascade_frontalface_default.xml')

cap = cv2.VideoCapture(0)
#To capture the video. 
#0- Live video
#or specify the path for your wanted video. 

while True:
#To capture video frames repeatedly.
    _,img = cap.read()
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, 2, 4)

    for (x,y,w,h) in faces:
        cv2.rectangle(img, (x,y),(x+w, y+h), (255,0,0),2)

    cv2.imshow('Image', img)
    key = cv2.waitKey(1)
    if key==ord('q'):#Tell it to exit the loop when the escape key is pressed.
        break

cap.release()
cv2.destroyAllWindows()

