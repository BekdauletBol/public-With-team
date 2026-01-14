# Public 🎓🛒

### A Localized Community Marketplace for University Students

**Public** is a modern iOS application designed to bridge the gap between traditional e-commerce and university community support.

Built with a **“Student-First”** philosophy, it allows users to:
- sell items (books, electronics, clothes)
- request favors (borrowing tools, finding study partners)

all within a **trusted university ecosystem**.

---

## 🚀 Key Features

- **Student Identity**  
  Secure registration and profile management tailored to university groups and classes.

- **Dynamic Marketplace**  
  Browse a real-time feed of items for sale or community requests.

- **Telegram-Inspired Profiles**  
  A sleek, modern user interface for managing personal data and profile avatars.

- **Instagram-Style Engagement**  
  Double-tap images to save them to a dedicated **Favorites** hub.

- **Direct Communication**  
  One-tap deep linking to **WhatsApp** and **Telegram** for instant negotiation and coordination.

- **Smart Search**  
  Filter the marketplace by item name or description to find exactly what you need.

---

## 🛠 Tech Stack (2026 Standards)

- **Language:** Swift 6 (Strict Concurrency & Thread Safety)
- **UI Framework:** SwiftUI
- **Architecture:** MVVM + Service-Oriented Architecture (SOA)
- **Backend:** Supabase *(I can not work w firebase due to region)*
- **Authentication:** Secure email/password authentication
- **Database:** PostgreSQL  
  Relational database for profiles, posts, and favorites
- **Storage:**  
  Cloud storage for compressed product images and user avatars

---

## 📱 Architecture Overview

**Public** follows a clean, decoupled architecture to ensure scalability and maintainability:

- **Models**  
  `Decodable / Encodable` structs matching Supabase schemas

- **Views**  
  Declarative SwiftUI views following Apple’s Human Interface Guidelines

- **ViewModels**  
  `@MainActor`-isolated logic managing state and user interaction

- **Services**  
  Singleton-based engine room handling network requests and external API integrations

---

## 🛠 Setup & Installation

1. Clone the repository  
2. Open `Public.xcodeproj` in **Xcode 17+**
3. Install the **Supabase SDK** via **Swift Package Manager**
4. Update `SupabaseConfig.swift` with:
   - Project URL  
   - Anon Public Key
5. Run the **Master SQL** script (found in project documentation) in the **Supabase SQL Editor** to initialize:
   - Tables  
   - RLS policies

---

