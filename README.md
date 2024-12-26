# Expense Tracker

Expense Tracker is a Flutter-based application designed to help users efficiently track and manage their personal expenses. This project employs a wide range of tools and packages to deliver a feature-rich and visually appealing experience.

---

## Features

- **Expense Management**: Add, edit, delete, and categorize expenses.
- **Data Persistence**: Save data locally using SQLite (via the Floor library).
- **Graphical Insights**: Visualize spending trends using interactive charts.
- **Notifications**: Set reminders or alerts for financial goals using local notifications.
- **Customization**: Pick images for transactions using the Image Picker.
- **Seamless Navigation**: Smooth page transitions with page indicators.
- **Time Zone Support**: Handle time-sensitive data effectively.

---

## Technologies and Packages Used

### **Core Flutter SDK**
- Provides the foundation for building the UI, widgets, and overall app structure.

### **State Management**
- **Provider**: A robust package for managing state across the application.

### **Database and Local Storage**
- **Floor**: A lightweight SQLite ORM for managing the app’s database.
- **Shared Preferences**: For storing key-value pairs, such as user preferences.

### **Notifications**
- **flutter_local_notifications**: Used to handle local notifications for reminders and alerts.

### **Charts and Data Visualization**
- **fl_chart**: For creating beautiful, interactive charts to visualize expense trends.

### **Icons and Animations**
- **flutter_feather_icons**: A collection of modern and clean icons.
- **lottie**: For adding captivating animations.
- **carbon_icons**: Additional icon set for enhanced UI elements.

### **Localization and Internationalization**
- **intl**: To support multiple locales and handle date/time formats effectively.

### **Testing**
- **Mockito** and **Mocktail**: Tools for unit testing with mock data.

### **Miscellaneous**
- **emoji_picker_flutter**: For integrating emoji pickers in expense descriptions.
- **smooth_page_indicator**: For page navigation with sleek indicators.
- **timezone**: To ensure consistency in time-related functionalities.
- **http**: To handle any network requests.
- **image_picker**: For attaching images to expense entries.

---

## Project Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/upretisaurav/expense_tracker.git
   cd expense_tracker
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the Application**:
   Ensure your device/emulator is ready, then:
   ```bash
   flutter run
   ```

---

## Assets

- **SVGs**: Stored in `assets/svg/`.
- **Images**: Stored in `assets/images/`.
- **Lottie Animations**: Stored in `assets/lottie/`.

### **Fonts**
- Custom fonts used:
  - **Inter-Bold**, **Inter-ExtraBold**, **Inter-Italic**, **Inter-Medium**, **Inter-Regular**, and **Inter-SemiBold**.

---

## Contributing

Contributions are welcome! Fork the repository, make your changes, and submit a pull request.

---

### **Contact**

For inquiries or feedback, feel free to reach out to the repository owner: [Saurav Upreti](mailto:upretisaurav7@gmail.com).
