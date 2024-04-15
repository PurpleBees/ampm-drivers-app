# AMPM Driver App

## Overview
AMPM Driver App revolutionizes the delivery management process by providing an intuitive and efficient solution for delivery drivers. By leveraging the power of Supabase, an open-source Firebase alternative, the app ensures seamless authentication, real-time order tracking, and secure storage for delivery proof images. From logging in securely with OTP authentication to capturing proof of delivery, AMPM Driver App offers a complete package for delivery professionals to streamline their workflow and enhance customer satisfaction.

## Key Features

### OTP Authentication
With OTP (One-Time Password) authentication, AMPM Driver App ensures that only authorized users gain access to the app. This secure login method verifies the identity of drivers, safeguarding sensitive delivery information.

### Real-time Order Tracking
Drivers can track assigned orders in real-time, enabling them to stay informed about delivery destinations, schedules, and any updates or changes to the orders. Real-time tracking enhances efficiency and allows drivers to plan their routes effectively.

### Delivery Status Management
Managing delivery statuses is simplified with AMPM Driver App. Drivers can easily mark deliveries as completed or failed within the app, providing accurate updates to dispatchers and ensuring smooth communication throughout the delivery process.

### Proof of Delivery
Capturing proof of delivery is essential for verifying successful deliveries and resolving disputes. AMPM Driver App allows drivers to capture and store delivery proof images directly within the app using Supabase Storage. These images serve as concrete evidence of completed deliveries, fostering trust between drivers and customers.

### Clean Architecture (MVVM)
AMPM Driver App follows a clean architecture pattern with Model-View-ViewModel (MVVM) design, ensuring separation of concerns and promoting code maintainability, scalability, and testability. This architecture enhances the app's robustness and facilitates future development and updates.

## Main Screens

### Home Screen
The Home Screen provides an overview of assigned orders and their current status. It allows drivers to quickly access important information about upcoming deliveries and prioritize their tasks accordingly.

### Delivery Update Screen
The Delivery Update Screen enables drivers to update the status of ongoing deliveries, marking them as completed or failed as necessary. It provides a streamlined interface for managing delivery statuses on the go.

### Delivery History/Detail Screen
The Delivery History/Detail Screen displays detailed information about past deliveries, including delivery timestamps, recipient details, and proof of delivery images. It allows drivers to review their delivery history and access relevant information for reference or documentation purposes.

## Profile (Drawer)
The Profile section, accessible from the Drawer menu, allows drivers to view and manage their profile information. It provides options for updating personal details, changing account settings, and accessing additional features or settings related to the user's account.

## Libraries Used
- **get:**
   A package for state management and navigation in Flutter applications.
- **intl_phone_field:** ^3.2.0
  Provides a customizable international phone input field widget for Flutter applications.
- **supabase_flutter:** ^2.3.4
  Offers Flutter bindings for Supabase, enabling seamless integration of Supabase services into Flutter apps.
- **pinput:** ^4.0.0
  Provides a customizable PIN input field widget for Flutter applications.
- **image_picker:** ^1.0.7
   Allows Flutter apps to select images from the device's gallery or camera.
- **path_provider:** ^2.1.2
   Provides a platform-agnostic way to access commonly used locations on the filesystem.
- **path:** ^1.9.0
  Offers utilities for working with file and directory paths in Dart.
- **otp_autofill:** ^3.0.2
  Enables automatic filling of OTP (One-Time Password) fields in Flutter apps.
- **intl:** ^0.19.0
  Provides internationalization and localization utilities for Dart and Flutter applications.
- **internet_connection_checker:** ^1.0.0+1
  Allows Flutter apps to check the device's internet connection status.
  

## How to Run the Repo
To run the AMPM Driver App repository, follow these steps:
1. Clone the repository to your local machine using Git:
   git clone https://github.com/PurpleBees/ampm-drivers-app.git
2. Navigate to the project directory:
   cd AMPM-Driver-App
3. Ensure that Flutter is installed on your machine. If not, follow the instructions on the [Flutter website](https://flutter.dev/docs/get-started/install) to install Flutter.
4. Run the following command to get the dependencies:
   flutter pub get
5. Connect your device or start an emulator.
6. Run the app using Flutter:
   flutter run
7. The app should now be running on your device or emulator, ready for testing and development.

