# Gradebook
An iOS app built with Swift 2.2 and Xcode 7.3. Uses Core Data, Firebase, and Alamofire. Allows students to record their and assignments and grades and calculates the grade in a course based on the assignments entered. 

## Required
Need to have the latest version of Swift and Xcode in order for Alamofire to work.

## Usage
A user can login with either their Facebook account, Udacity account, or create an account by entering an email and password in the login page and pressing the "Sign Up" button. The information saved through Core Data will be associated with each account. One user logging in with different accounts (eg. Facebook and Udacity) will be treated as two different users and Core Data will fetch and save the data that is connected with each account. 

New courses can be entered by pressing the "+" button in the upper right corner of the "Courses" page and clicking on a course will navigate the user to a page listing the assignments associated with that course. Assignments can be added the same way courses are added, by pressing the "+" button in the upper right corner. Once a course has at least one assignment, the user can see the total grade and other information about the course by clicking on the "See Grade" button on the tool bar at the bottom. 

## Tasks remaining
- [ ] If no assignments, don't show grade
- [ ] On login page, resign first responder if screen tapped
- [ ] Create new view controller for sign up

## Attributions 
The icon used for the app was created by Lil Squid from Noun Project 

## Licensing 
The contents of this repository is licensed under [The MIT License](https://opensource.org/licenses/MIT)

