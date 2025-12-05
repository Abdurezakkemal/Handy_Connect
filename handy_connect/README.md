

# Handy Connect

Handy Connect is a Flutter mobile application that connects customers with skilled handymen for various household and professional services.  
Customers can easily find, book, and manage services, while handymen can manage their profiles and job requests in one place.


## Features

- **User Authentication**

  - Email/password registration and login.
  - Separate flows for customers and handymen.
  - Secure session management using Firebase Authentication.

- **Customer Features**

  - Browse available handymen and view detailed profiles.
  - Filter handymen by category / skill (e.g., electrician, plumber, painter, etc.).
  - Book services and create new job requests.
  - View and manage upcoming and past appointments.
  - View job status (e.g., pending, accepted, in-progress, completed).

- **Handyman Features**

  - Create and manage a professional profile (name, skills, experience, pricing, etc.).
  - Upload profile picture using `image_picker` and upload to Cloudinary.
  - View incoming job requests from customers.
  - Accept or reject requests.
  - View list of assigned jobs and appointment schedule.

- **General**
  - Clean navigation using `go_router`.
  - State management with `flutter_bloc` for predictable and testable state.
  - Internationalization support with `intl` (for dates, currencies, etc.).
  - Dependency injection with `get_it` for better testability and modularity.

---

## Screenshots

<p align="center">
  <img src="im1.jpg" alt="Screenshot 1" width="45%" />
  <img src="im2.jpg" alt="Screenshot 2" width="45%" />
  <br/>
  <img src="im3.jpg" alt="Screenshot 3" width="22.5%" />
  <img src="im4.jpg" alt="Screenshot 4" width="22.5%" />
  <img src="im5.jpg" alt="Screenshot 5" width="22.5%" />
</p>


---

## Technologies Used

- **Framework**: Flutter
- **State Management**: `flutter_bloc`
- **Backend**: Firebase
  - Authentication
  - Cloud Firestore
- **Routing**: `go_router`
- **Dependency Injection**: `get_it`
- **Functional Utilities**: `dartz`
- **Value Equality**: `equatable`
- **Date/Intl**: `intl`
- **Image Handling**:
  - `image_picker`
  - Cloudinary (image hosting)

---

## Architecture & Concepts

- **Feature-First Organization**  
  Code is grouped by feature (`auth`, `customer`, `handyman`) instead of by layer only, improving modularity and readability.

- **Bloc (flutter_bloc)**

  - Used to handle UI state, events, and side-effects.
  - Each major screen or flow has its own `Bloc`/`Cubit` for clarity.

- **Use Cases / Core Logic**

  - Business rules and core operations are encapsulated in `usecase` classes under `lib/core/usecase` (and/or feature-specific usecases).
  - Makes it easier to test and reuse logic.

- **Dependency Injection (get_it)**

  - All repositories, data sources, and blocs are registered in a service locator.
  - Improves testability and reduces tight coupling between classes.

- **Functional Error Handling (dartz, equatable)**
  - `Either<Failure, T>` patterns (if used) to handle success/failure flows more clearly.
  - `equatable` to easily compare value objects, states, and entities.

---


## Key Flows

- **Onboarding & Authentication**

  - User selects role (customer or handyman) or logs in directly.
  - Auth state is managed by Bloc and Firebase Authentication.

- **Customer Journey**

  - Browse list of handymen (data from Firestore).
  - Open handyman profile to see details and reviews.
  - Create a booking / service request.
  - Monitor request status and upcoming appointments.

- **Handyman Journey**
  - Complete profile details (skills, price, description).
  - See new job requests and respond (accept/reject).
  - View and manage confirmed jobs and schedule.

---

## Getting Started

### Prerequisites

- Flutter SDK
- A configured IDE (like VS Code or Android Studio)

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/handy_connect.git
   ```
2. Navigate to the project directory:
   ```sh
   cd handy_connect
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```

### Running the Application

```sh
flutter run
```

## Project Structure

The project follows a feature-driven architecture:

- `lib/core`: Contains shared code, utilities, and core functionalities.
- `lib/features`: Contains the individual features of the application, such as `auth`, `customer`, and `handyman`.
- `lib/main.dart`: The entry point of the application.
