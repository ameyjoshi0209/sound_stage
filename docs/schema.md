# 🗄️Sound Stage Database Schema

This document outlines the **database schema** for the **Sound Stage** platform 🎤🎶. 

The application utilizes **Google Firebase Firestore** as its backend database, leveraging the power of a **NoSQL document-based model** 📚. This approach allows for **scalable**, **flexible**, and **real-time** data management, ensuring a smooth and dynamic user experience 🌐⚡.

Data within the platform is organized into logical **collections** that represent the core entities of the system, which include:

- **Customers** 🎟️
- **Organizers** 👥
- **Events** 🎉
- **Tickets** 🎫

Each collection is designed to optimize the platform’s performance and maintainability, ensuring an efficient and seamless experience for both users and administrators.


&nbsp;
## 📋 Collections and Fields

### 1. Customer Collection

| Field | Type | Description |
|------|------|-------------|
| `age` | String | Customer's age |
| `email` | String (PK) | Customer's email |
| `image` | String | URL to profile image (Cloudinary) |
| `name` | String | Customer's full name |
| `password` | String | Hashed password |
| `phone` | String | Phone number |
| `role` | String | Role = 'Customer' |
| `userId` | String | Unique customer ID |


&nbsp;
### 2. Organizer Collection

| Field | Type | Description |
|------|------|-------------|
| `orgApproved` | Boolean | Organizer approval status |
| `orgAddress` | String | Organizer's address |
| `orgEmail` | String | Organizer email (PK) |
| `orgFacebook` | String | Facebook page link |
| `orgId` | String | Unique organizer ID |
| `orgImage` | String | Profile image URL |
| `orgName` | String | Name of organization |
| `orgPassword` | String | Organizer's password (hashed) |
| `orgPhone` | String | Contact number |
| `orgWebsite` | String | Official website link |
| `role` | String | Role = 'Organizer' |


&nbsp;
### 3. Event Collection

| Field | Type | Description |
|------|------|-------------|
| `AgeAllowed` | String | Minimum age allowed |
| `Category` | String | Concert category |
| `Date` | String | Event date |
| `Details` | String | Event description |
| `EventApproved` | Boolean | Admin approval status |
| `EventId` | String | Unique event ID |
| `Image` | String | Event image URL |
| `Location` | String | Event location |
| `Name` | String | Event name |
| `OrganizerId` | String | Linked organizer ID |
| `Price` | String | Ticket price |
| `Time` | String | Event start time |


&nbsp;
### 4. Tickets Collection

| Field | Type | Description |
|------|------|-------------|
| `Attended` | Boolean | Attendance status |
| `CustomerEmail` | String | Customer's email |
| `CustomerId` | String | Customer unique ID |
| `CustomerImage` | String | Customer profile image |
| `CustomerName` | String | Customer full name |
| `EventDate` | String | Date of event |
| `EventId` | String | Event ID |
| `EventImage` | String | Event image URL |
| `EventLocation` | String | Event location |
| `EventName` | String | Event title |
| `EventPrice` | String | Ticket price |
| `EventTime` | String | Event time |
| `Number` | String | Number of tickets |
| `OrganizerId` | String | Organizer unique ID |
| `Total` | String | Total amount paid |


&nbsp;
## 🛠 Notes

- Firestore automatically indexes collections.
- Organizer & Event approval is mandatory for visibility.
- QR code is mapped to Ticket for entry validation.
