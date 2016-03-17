# Savvy
CPE 458 Project
dnewberr | crhoads

HARDWARE CONSTRAINTS
Tested and used on an iPhone 5/5s. Certain external frameworks aren't set up in our project to work on other devices like the iPad.
Not designed to work in landscape mode.


TEST USERS
Facebook Test User:
Email: savvy_qeucvph_student@tfbnw.net
Password: testuser

Quizlet Test User:
Username: cpe458-savvy
Password: testuser


HOW TO CHECK APIs
FACEBOOK
- The first screen should have a Facebook login button. When pressed, this'll take you to a web page where you can use the test user to log in. From here, allowing permissions should automatically segue into the main home screen, and "User was successfully logged in to Facebook." should print to the console.
- From here, clicking logout should confirm that you wish to log out of Facebook. If confirmed, "User will now be logged out of Facebook." should print to the console and then the screen will segue back to the original Facebook login screen.
- If a user starts Savvy and has already gone through the Facebook login process, the console will print "User was successfully logged in to Facebook." and will be automatically directed to the hime screen.

QUIZLET
- After logging into Facebook and reaching the home screen, select the “Import from Quizlet” option. This opens up Safari and automatically goes to the Quizlet log in screen. Log in using the username and password specified above. Select “Allow” to let Savvy use the information on the test Quizlet account. After you select “Open”, Savvy opens back up and the JSON for the test account’s Quizlet sets is printed to the console.

Project Workload Split - Vertical Prototype
CODY:
*Quizlet integration on the home screen (1)
Home/View Set (2)
Study Page (1)
Daily Review (1)

DEBORAH:
Facebook integration on the startup (1)
Create/Edit Set (2)
Badges (1)
Game (1)
