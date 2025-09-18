# WiseChoice - Career Guidance App

WiseChoice is a mobile application built with **Flutter** and powered by a **FastAPI** backend.  
The app helps students and job seekers explore career paths by providing:

- Personalized job recommendations
- Recommended courses
- Bookmarking functionality
- AI-powered career guidance

---

## 📱 Features

- **User Authentication** (Signup, Login, Profile Management with JWT tokens)
- **Personalized Career Recommendations** powered by AI (via OpenRouter / Gemini API)
- **Job Listings** (with detailed views and external application links)
- **Course Listings** (top-rated online courses relevant to user interests)
- **Bookmarks** (save jobs and courses to revisit later)
- **Dark/Light Theme** support using Provider
- **Cross-platform**: Works on both Android and iOS

---

## 🛠️ Tech Stack

### Frontend (Flutter)

- `provider` (state management)
- `http` (API calls)
- `shared_preferences` (local storage for authentication tokens)
- `flutter_secure_storage` (securely storing tokens if required)
- `intl` (date/time formatting)
- `url_launcher` (open external job/course links)
- `flutter_dotenv` (environment variable management)

### Backend (FastAPI)

- `fastapi`
- `uvicorn`
- `pydantic`
- `sqlalchemy`
- `passlib` (password hashing)
- `python-jose` (JWT authentication)
- `requests` (API calls to external services)

### AI & External APIs

- **OpenRouter** for AI responses (career recommendations)
- **Job APIs** (free sources for job listings)
- **Course datasets/APIs** (for relevant courses)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Python 3.9+ installed
- Node.js (optional, for running mock APIs if needed)

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/picasso653/career_guidance_app.git
cd career_guidance_app
```

### 2️⃣ Setup Backend (FastAPI)

```bash
cd backend
python -m venv venv
source venv/bin/activate   # On Windows: venv\Scripts\activate
pip install -r requirements.txt

# Run the server
uvicorn main:app --host 0.0.0.0 --port 8001
```

### 3️⃣ Setup Frontend (Flutter)

```bash
cd frontend
flutter pub get
flutter run
```

---

## ⚙️ Configuration

### Backend

- Update `.env` file in `backend/` with:

```txt
OPENROUTER_API_KEY=your_key_here
DATABASE_URL=sqlite:///./wisechoice.db
SECRET_KEY=your_secret_key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

### Frontend

```dart
const String baseUrl = "https://your-render-app.onrender.com";
```

---

## 📂 Project Structure

```txt
wisechoice/
│── backend/              # FastAPI backend
│   ├── main.py           # Entry point
│   ├── models/           # Database models
│   ├── routes/           # API routes
│   ├── auth/             # Authentication logic
│   ├── services/         # External API calls (AI, jobs, courses)
│   └── database.py       # Database setup
│
│── frontend/             # Flutter frontend
│   ├── lib/
│   │   ├── main.dart     # App entry point
│   │   ├── screens/      # UI screens (Home, Recommendations, Bookmarks)
│   │   ├── providers/    # State management using Provider
│   │   └── models/      # API integration
│   └── pubspec.yaml      # Flutter dependencies
│
└── README.md             # Project documentation
```

---

## 🛡️ License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

- **Isaac Korankye Asante**  
Final Year Student, 2025  
