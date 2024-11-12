# MessageMate

MessageMate is a **real-time chat application** built with **Flutter**, **Dart**, and **Firebase**. It allows users to send messages, create profiles, and interact with others in a secure and seamless way. The app leverages **Firebase Firestore** for message storage and retrieval and **Firebase Authentication** for user management.

## Features
- **Real-time Messaging**: Send and receive messages instantly using **Firebase Firestore** for efficient message storage and retrieval.
- **User Authentication**: Users can sign up, log in, and log out using **Firebase Authentication** with email-password authentication.
- **User Profiles**: Users can create and update their profiles by setting usernames and uploading profile pictures.
- **Cross-Platform**: Built with **Flutter**, ensuring the app works seamlessly on both Android and iOS devices.

## Tech Stack
- **Flutter**: A UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- **Dart**: The programming language used to develop the Flutter application.
- **Firebase**:
  - **Firebase Firestore** for storing and retrieving messages.
  - **Firebase Authentication** for handling user authentication.
  
## Project Structure
- **lib/main.dart**: The entry point for the Flutter app, setting up the app structure and routing.
- **lib/screens**: Contains various screens such as login, chat, and profile screens.
- **lib/services**: Contains Firebase service functions for authentication and Firestore operations.
- **lib/models**: Contains model classes for managing user data and chat messages.

## Getting Started

### Prerequisites
- Install **Flutter**: Follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- Install **Dart**: Dart is bundled with Flutter, so no separate installation is needed.
- Firebase Project: Set up a Firebase project in the [Firebase Console](https://console.firebase.google.com/), and enable Firebase Authentication and Firestore.

### Setup Instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/OmDixit2107/MessageMate.git
   cd MessageMate
