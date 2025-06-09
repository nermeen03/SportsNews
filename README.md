
# 🏆 SportsNews – iOS Sports App

**SportsNews** is a feature-rich iOS application that provides users comprehensive information on various sports leagues and events. Built using Swift, this app delivers a seamless and intuitive user experience with support for multiple languages, dark mode, and robust offline handling.

## 📱 Features

### 🎬 User Flow

* **Splash Screen**: A branded entry point shown upon launch.
* **Onboarding Screen**: Displays only once after installation, storing the onboarding completion flag in `UserDefaults`.

### 🏠 Home Screen

* Displays 4 major sports as selectable categories:

  * 🏈 Football
  * 🏀 Basketball
  * 🎾 Tennis
  * 🏏 Cricket

### 🏟️ League Details

* Tapping on a sport displays its respective leagues.
* **Search bar** available for quick filtering.
* Each league screen includes:

  * **Upcoming Events**: Match title, competing teams, date/time.
  * **Past Events**: Match title, competing teams, date/time, and score (if available).
  * **Participating Teams**.

### 👥 Team Details (Football Only)

* Upon selecting a football team:

  * Displays detailed information about **players** and **coaches**.

### ⭐ Favorites

* Users can mark leagues as favorite.
* Favorites are stored using **Core Data** and accessed from the **Favorites** tab.
* **Search bar** available for quick filtering.

### 🌐 Connectivity

* Uses real-time network monitoring with alerts on connectivity changes.
* Restricts navigation when there is no internet connection, ensuring data integrity.

### 🧪 Unit Testing

* Includes unit tests for network-layer functions to ensure reliable API communication.

### 🌍 Localization & Accessibility

* Full support for:

  * **Languages**: English (EN) and Arabic (AR)
  * **Layout Directions**: LTR & RTL
  * **Themes**: Light & Dark mode
  * **Orientations**: Portrait and Landscape

## 🧰 Technologies Used

* **Language**: Swift
* **Architecture**: MVP
* **Persistence**: Core Data, UserDefaults
* **Networking**: Alamofire
* **UI**: UIKit 
* **Localization**: NSLocalizedString, base localization
* **Connectivity**: Connectivity

## Demo  
![SportsNews Demo](https://www.dropbox.com/scl/fi/gfkfa8g2rspssb1p7ibl6/video.mp4?rlkey=0ik3iycgn2y98i3b7njobmcd6&st=vjzihmbw&dl=0)

## 🚀 Getting Started

### Prerequisites

* Xcode 15+
* iOS 17+
* Swift 5.5+

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/nermeen03/SportsNews.git
   cd SportsNews
   ```

2. Open the project in Xcode:

   ```bash
   open SportsNews.xcodeproj
   ```

3. Build and run on a simulator or physical device.

## ✅ Tests

Run unit tests using the Xcode test navigator or the command line:

```bash
Cmd + U
```

Test coverage includes:

* Network service responses
* Error handling
* Parsing validation

## 👥 Contributors

- [Mario Abdelmaseeh](https://www.linkedin.com/in/mario-abdelmaseeh)
- [Nermeen Mohamed](https://www.linkedin.com/in/nermohamed14)
