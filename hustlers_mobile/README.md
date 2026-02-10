# Hustlers Mobile 🚀

**Hustlers Mobile** is a powerful Flutter application designed to empower job seekers, freelancers, and business development professionals. It goes beyond simple job searching by providing deep AI-driven insights into companies, helping users identify opportunities and crafting the perfect outreach pitch to land deals.

## ✨ Key Features

### 🔍 Smart Job & Company Finder
*   **Location-Based Search:** Find companies and opportunities in specific cities (e.g., Addis Ababa, Adama, Hawassa).
*   **Category Filtering:** Filter by industry (Tech, Hotel, Health, etc.).
*   **Search Modes:** Supports Fast, Normal, and Deep Large Scale findings.

### 🤖 AI Company Insights
Unlock the power of data with our advanced company analysis tool:
*   **Current State Analysis:** Evaluate a potential client's digital presence and online visibility.
*   **Pain Point Identification:** Automatically detect key problems the company is facing.
*   **Business Impact:** Quantify lost leads and revenue leakage.
*   **Recommended Solutions:** Get tailored suggestions for Website, SEO, and Marketing improvements.
*   **Auto-Generated Pitch:** The app generates a customized **Cold Outreach Pitch** and Call-To-Action (CTA) to help you approach the company with confidence.

### 📊 Dashboard & Analytics
*   Centralized dashboard for quick access to all tools.
*   Visual data representation using charts and graphs.

### 💾 Saved Opportunities
*   Bookmark interesting companies and jobs for later review.
*   Manage your prospect list efficiently.

### 📱 Modern UI/UX
*   **Clean Architecture:** Built with scalability and maintainability in mind.
*   **Responsive Design:** Optimized for mobile devices.
*   **Beautiful Visuals:** Uses Google Fonts, gradients, and smooth animations.

## 🛠️ Tech Stack

This project is built using **Flutter** and follows a feature-first **Clean Architecture** approach.

*   **Framework:** [Flutter](https://flutter.dev/) & [Dart](https://dart.dev/)
*   **State Management:** [Riverpod](https://riverpod.dev/) (Hooks & Code Generation)
*   **Networking:** `http`
*   **Local Storage:** `shared_preferences`, `sqflite`
*   **UI Components:** 
    *   `google_fonts`
    *   `fl_chart` & `percent_indicator` for analytics
    *   `curved_navigation_bar`
    *   `smooth_page_indicator`
*   **Utilities:** `url_launcher`, `file_picker`, `intl`

## 📂 Project Structure

The project is organized by features to ensure modularity:

```
lib/
├── core/                # Shared utilities, constants, and widgets
├── features/            # Feature-specific code
│   ├── dashboard/       # Main app dashboard
│   ├── job_finder/      # Job search & Company AI Insights
│   ├── onboarding/      # User onboarding flow
│   ├── saved/           # Saved items functionality
│   ├── analysis/        # Analytics features
│   └── resume/          # Resume building tools
├── main.dart            # Application entry point
└── ...
```

## 🚀 Getting Started

### Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install)
*   [Dart SDK](https://dart.dev/get-dart)
*   An IDE (VS Code or Android Studio)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/hustlers_mobile.git
    cd hustlers_mobile
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the application:**
    ```bash
    flutter run
    ```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1.  Fork the project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
Built with ❤️ by the Biruk Tadele.
