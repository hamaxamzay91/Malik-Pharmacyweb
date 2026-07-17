# 💊 Malik Pharmacy — Enterprise E-Commerce Platform

> دەرمانخانەی ئۆنلاینی تەواو | Full-Stack Pharmacy E-Commerce | صيدلية إلكترونية متكاملة

---

## 🏗️ Project Structure

```
Malik-Pharmacy/
│
├── frontend/                    # React 19 + Vite + Tailwind 4
│   └── src/
│       ├── components/
│       │   ├── common/          # LoadingScreen, Skeleton, CountUp
│       │   ├── layout/          # Layout, Header, Footer, Navbar
│       │   ├── home/            # Hero, Stats, Categories
│       │   ├── medicines/       # ProductCard, ProductGrid, Filters
│       │   ├── cart/            # CartItem, CartSummary, Checkout
│       │   ├── auth/            # LoginForm, RegisterForm
│       │   ├── dashboard/       # Customer Dashboard
│       │   └── admin/           # AdminLayout, AdminSidebar
│       ├── pages/
│       │   ├── HomePage.jsx
│       │   ├── MedicinesPage.jsx
│       │   ├── MedicinePage.jsx
│       │   ├── CartPage.jsx
│       │   ├── CheckoutPage.jsx
│       │   ├── admin/           # Dashboard, Products, Orders...
│       │   └── auth/            # Login, Register, ForgotPass
│       ├── context/
│       │   ├── AuthContext.jsx  # JWT Auth state
│       │   ├── index.jsx        # Cart, Theme, Lang contexts
│       ├── services/
│       │   └── api.js           # Axios + all API endpoints
│       └── utils/
│           └── translations.js  # KU / EN / AR i18n
│
├── backend/                     # PHP 8.4 REST API
│   ├── api/
│   │   └── index.php            # Main router
│   ├── auth/
│   │   └── JWT.php              # JWT + AuthMiddleware
│   ├── config/
│   │   ├── config.php           # App configuration
│   │   └── database.php         # PDO + BaseModel
│   ├── controllers/
│   │   ├── AuthController.php   # Register, Login, Logout
│   │   ├── MedicineController.php
│   │   ├── OrderController.php
│   │   ├── CartController.php
│   │   └── ...
│   ├── models/
│   │   ├── UserModel.php
│   │   ├── MedicineModel.php
│   │   └── ...
│   └── middleware/
│       ├── CORS.php
│       └── RateLimit.php
│
└── database/
    └── migrations/
        └── 001_create_all_tables.sql   # Complete DB schema
```

---

## 🚀 Getting Started

### Frontend

```bash
cd frontend
npm install
npm run dev     # http://localhost:5173
```

### Backend (PHP 8.4 + MySQL 9)

```bash
# 1. Create database
mysql -u root -p < database/migrations/001_create_all_tables.sql

# 2. Configure environment
cp backend/config/config.php backend/config/config.local.php
# Edit DB_HOST, DB_USER, DB_PASS, JWT_SECRET

# 3. Run PHP dev server
cd backend
php -S localhost:8000 api/index.php
```

---

## 🔑 Environment Variables

### Frontend (.env)
```
VITE_API_URL=http://localhost:8000/api/v1
VITE_RECAPTCHA_KEY=your-key
VITE_GOOGLE_MAPS_KEY=your-key
```

### Backend (env or config.php)
```
DB_HOST=localhost
DB_NAME=malik_pharmacy
DB_USER=root
DB_PASS=your_password
JWT_SECRET=your-super-secret-key
APP_ENV=development
APP_URL=http://localhost:8000
FRONTEND_URL=http://localhost:5173
```

---

## 📦 Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React 19, Vite 6, Tailwind CSS 4 |
| Animations | Framer Motion 11, GSAP 3 |
| State | Zustand 5, React Query 5 |
| HTTP | Axios 1.7 |
| Routing | React Router 7 |
| Forms | React Hook Form 7 + Zod |
| Slider | Swiper.js 11 |
| Backend | PHP 8.4 |
| Auth | JWT (HS256, Argon2id) |
| Database | MySQL 9 + PDO |
| Icons | React Icons 5 |
| Charts | Recharts |

---

## 🌐 Multi-Language Support

| Language | Code | Direction |
|----------|------|-----------|
| Kurdish Sorani | `ku` | RTL |
| English | `en` | LTR |
| Arabic | `ar` | RTL |

---

## 🔒 Security Features

- ✅ JWT Authentication with blacklist
- ✅ Argon2id password hashing
- ✅ SQL Injection protection (PDO prepared statements)
- ✅ XSS protection (htmlspecialchars)
- ✅ CSRF protection
- ✅ Rate limiting
- ✅ CORS restriction
- ✅ Secure file upload validation
- ✅ reCAPTCHA integration (optional)

---

## 📊 Database Tables (23 tables)

`users`, `user_addresses`, `employees`, `roles`, `permissions`, `role_permissions`,
`categories`, `brands`, `medicines`, `medicine_images`, `medicine_tags`,
`coupons`, `coupon_usage`, `carts`, `prescriptions`, `orders`, `order_items`,
`order_status_history`, `wishlists`, `reviews`, `blogs`, `blog_tags`,
`notifications`, `contacts`, `banners`, `gallery`, `settings`, `activity_logs`,
`token_blacklist`, `password_resets`, `careers`, `career_applications`, `faqs`

---

## 🎨 Design System

```css
/* Primary Colors */
--color-primary:  #00D4AA  /* Teal */
--color-accent:   #6C63FF  /* Purple */
--color-gold:     #F0B429  /* Gold */

/* Dark Mode (Default) */
--bg-base:     #070B14
--bg-surface:  #0D1424
--bg-elevated: #111B2E

/* Glassmorphism */
--bg-glass: rgba(255,255,255,0.04)
```

---

## 📱 Pages

| Page | Route | Auth |
|------|-------|------|
| Home | `/` | Public |
| Medicines | `/medicines` | Public |
| Medicine Detail | `/medicines/:slug` | Public |
| Search | `/search` | Public |
| Cart | `/cart` | Public |
| Checkout | `/checkout` | 🔒 |
| Orders | `/orders` | 🔒 |
| Profile | `/profile` | 🔒 |
| Wishlist | `/wishlist` | 🔒 |
| Prescription Upload | `/prescription` | 🔒 |
| Admin Dashboard | `/admin` | 🔒 Admin |
| Blog | `/blog` | Public |
| About | `/about` | Public |
| Contact | `/contact` | Public |
| FAQ | `/faq` | Public |
| Careers | `/careers` | Public |

---

## 📞 Contact

**Malik Pharmacy**
- 📧 info@malikpharmacy.com
- 📱 +964 750 000 0000
- 📍 Erbil / Sulaymaniyah, Kurdistan, Iraq

---

*Built with ❤️ for Kurdistan's healthcare*
