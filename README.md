# Al Khalifa Restaurant - Admin Dashboard


A premium, responsive, and modern Flutter web dashboard built for managing the operations of **Al Khalifa Restaurant & Convention Hall**. This dashboard provides a comprehensive suite of tools for administrators to manage menus, products, orders, and system configurations efficiently.

## ✨ Key Features

- **Dynamic Dashboard**: Real-time stats visualization for revenue, active listings, menus, and pending orders.
- **Menu Management**: Full CRUD operations for products and party menus with category association.
- **Category System**: Organize products into custom categories with ease.
- **Order Tracking**: Manage and track customer orders, payment status, and delivery details.
- **Customer Insights**: View and manage the customer base.
- **System Configuration**:
    - Manage **Delivery Areas** and **Delivery Fees**.
    - Control **Home Sliders** for marketing.
    - Organize **Product Sections** for better display.
- **Admin Profile**: Personalized header showing admin name, role, and profile photo.
- **Responsive UI**: Optimized for Mobile, Tablet, and Desktop views.
- **Clean URLs**: Powered by Path URL Strategy (no `#` in the URL).
- **Secure Login**: Admin authentication with a password visibility toggle.

## Getting Started

### Prerequisites

- Flutter SDK (v3.10.1 or higher)
- Dart SDK
- A modern web browser

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/alkhalifa_dashboard_flutter.git
   cd alkhalifa_dashboard_flutter
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app locally**:
   ```bash
   flutter run -d chrome
   ```

## 🐳 Docker Support

To run the application using Docker:

1. **Build the image**:
   ```bash
   docker build -t alkhalifa-dashboard .
   ```

2. **Run the container**:
   ```bash
   docker run -p 8080:80 alkhalifa-dashboard
   ```
   Access the dashboard at `http://localhost:8080`.

## 🚢 Continuous Integration & Deployment

The project includes a pre-configured **GitHub Actions** workflow for seamless deployment to **GitHub Pages**.

- **Workflow File**: `.github/workflows/deploy.yml`
- **Trigger**: Automatically runs on every push to the `main` branch.
- **Clean URLs**: Configured with `--base-href "alkhalifa_dashboard_flutter"`.

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **Networking**: [HTTP](https://pub.dev/packages/http)
- **Local Storage**: [GetStorage](https://pub.dev/packages/get_storage)
- **Charts**: [FL Chart](https://pub.dev/packages/fl_chart)
- **Routing**: Path URL Strategy for clean URLs

## UI/UX Highlights

- **Aesthetic Design**: Uses a clean, professional color palette (Al Khalifa Green & White).
- **Interactive Elements**: Smooth transitions and responsive layouts.
- **Premium Icons**: Integrated with Material and Font Awesome style icons.

---

Built with @robiulsunnyemon
