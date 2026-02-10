# Hustlers Mobile 🚀

**Hustlers Mobile** is a high-performance, cross-platform mobile application designed to bridge the gap between job seekers/freelancers and potential clients. Unlike traditional job boards, Hustlers Mobile leverages **Generative AI** to provide deep business intelligence on companies, identifying their pain points and auto-generating cold outreach pitches to help users land deals proactively.

## 📋 Executive Summary
A feature-rich Flutter application built with Clean Architecture that empowers users to go beyond simple job searching. It conducts specific "Deep Scans" on potential client companies to identify revenue leakage and digital presence gaps, then provides actionable solutions and outreach scripts.

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

## 🛠️ Core Competencies & Tech Stack

This project is built using **Flutter** (SDK >3.10) and follows a feature-first **Clean Architecture** approach, ensuring scalability and testability.

*   **Frameworks:** [Flutter](https://flutter.dev/) & [Dart](https://dart.dev/)
*   **State Management:** [Riverpod](https://riverpod.dev/) (Hooks & Code Generation)
*   **Architecture:** Feature-First Clean Architecture (Domain, Data, Presentation layers)
*   **Networking:** `http` (RESTful API, Multipart/Form-Data, JSON parsing)
*   **Data Persistence:** `sqflite` (Local Cache), `shared_preferences`
*   **AI Integration:** LLM Response Parsing (Markdown/JSON cleaning & structured data mapping)
*   **UI Components:** 
    *   `google_fonts`
    *   `fl_chart` & `percent_indicator` for data visualization
    *   `curved_navigation_bar`
    *   `smooth_page_indicator`
*   **Utilities:** `url_launcher`, `file_picker`, `intl`

## 🏗️ System Architecture & Engineering

*   **Modular Design:** The codebase is strictly divided into functional features (`analysis`, `job_finder`, `dashboard`), preventing spaghetti code and enabling independent module testing.
*   **Dependency Injection:** Uses Riverpod's logical separation to inject Repositories and Datasources, ensuring easy mocking and testing.
*   **Robust Error Handling:** Implemented granular Exception handling for Socket, Format, and HTTP errors to ensure app stability during poor network conditions.
*   **Deep Integration:**
    *   **AI Business Analyst:** Integrates with custom backend endpoints (`/api/v1/map/company/insights`) to perform deep scans on companies.
    *   **Resume Consultant:** Features a Multipart file upload system for PDF processing (`/api/v1/resume/suggestions/pdf`).

## 📊 Performance Metrics

*   **API Efficiency:** Optimized JSON parsing with safe-guards against complex LLM markdown responses.
*   **UI Fluidity:** Heavy usage of `fl_chart` and `smooth_page_indicator` optimized for 60fps performance without main-thread blocking.

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
