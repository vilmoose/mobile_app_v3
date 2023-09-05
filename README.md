# mobile_app_v3

A Flutter project for the NACHO system. The application is meant to be paired with a Raspberry Pi equipped with a tilt&pan servo and a Pi Camera. The purpose of the app is to be able to monitor, record, and control the security system. The app has a login page (Figure 1) where the users enter their login info and upon successful credentials, logged into the home page (Figure 2). From their the user has options to: check the status of each camera(Figure 3), get a live feed for the camera(s)(Figure 4), control the camera to observe surroundings, and take a picture/video. Additionally, there is a library(Figure 5) where all previous pictures/recordings are stored (using a Firebase Database). The sole author of the application is Vilmos Feher; work on the application has been stopped since the project was terminated, I might come back to fix it up later down the road. 

*Setup of this application requires setup of Flutter, the mobile phone emulator,an active Firebase Database, and the Raspberry Pi Module(RaspPi 3, RPiCamV2, tilt&pan servos).

## Figures
![gui login](https://github.com/vilmoose/mobile_app_v3/assets/36927842/8e6ce6eb-61bd-40a2-afb6-983079d5f1a8) Figure 1
![gui home ](https://github.com/vilmoose/mobile_app_v3/assets/36927842/abaf0b54-503b-47fa-beef-c378f55288e2) Figure 2
![gui camera settings](https://github.com/vilmoose/mobile_app_v3/assets/36927842/143b60cb-de5a-4aa4-bf90-c2a50750dda2) Figure 3
![gui live feed](https://github.com/vilmoose/mobile_app_v3/assets/36927842/b445d95b-7b02-46b7-9edf-e0d0e1fbf170) Figure 4
![gui library](https://github.com/vilmoose/mobile_app_v3/assets/36927842/b193ef8c-5cb8-4309-8563-9c0187a9d30f) Figure 5


