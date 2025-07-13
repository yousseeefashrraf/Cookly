# 🍳 Cookly — Your Interactive Cooking Companion

Cookly is a modern iOS cooking timer app built entirely with Swift and SwiftUI. It combines beautiful UI, dynamic filtering, custom countdown logic, and animated interaction to create a focused cooking experience.

---

## 📱 Features

- ✅ **Custom Countdown Timer**
  - CoreGraphics circular trim with animation
  - Gradient progress ring
  - Timer controls with pause/play/reset

- 🧠 **MVVM Architecture**
  - Clean separation of concerns
  - Custom `TimerManagerViewModel` for logic
  - Observable view models

- 🎨 **Smooth UI & Animations**
  - PhaseAnimator & bouncy drag animations
  - Responsive layouts using `GeometryReader`
  - LinearGradients, shape masking, scale effects

- ✨ **Scroll-Based Scaling Animation**
  - Horizontal scroll view with **dynamic card scaling**
  - Uses `GeometryReader` to track scroll offset and apply `scaleEffect` per item
  - Smooth App Store–like focus feedback on center card

- 🍳 **Draggable Timer Bubble**
  - Drag-to-reposition logic
  - Custom gesture handling
  - Snaps left/right with smart positioning

- 🔍 **Recipe Filtering**
  - Tag-based filters (tags, cuisines, meal types)
  - Real API from dummyjson.com
  - Localized dynamic filter generation

- 📦 **Extras**
  - AsyncImage support with placeholder skeletons
  - Haptic feedback
  - Reusable components

---

## 🛠️ Tech Stack

- **Language:** Swift
- **UI Framework:** SwiftUI
- **Architecture:** MVVM
- **API:** DummyJSON
- **Utilities:** TimerPublisher, CoreGraphics, LinearGradients, GeometryReader
- **Animations:** `PhaseAnimator`, `.bouncy`, `.snappy`, scaling & trimming

---

## 📸 Screenshots

| Home View | Bubble Timer| Countdown View |
|---|---|---|
| ![Home](https://github.com/user-attachments/assets/21e9f9d5-d19d-4a76-bc04-a9bbf629b58b) | ![Bubble](https://github.com/user-attachments/assets/fe0a27e6-131a-4c31-a932-56591d642b0d) | ![Timer](https://github.com/user-attachments/assets/0e2195ec-5d32-4e50-bb40-f446a352e4bf) |

## Demo Video
📺 [Watch the demo on YouTube](https://youtube.com/shorts/vUk31t-aZ8I?feature=share)
---

## 🧠 What I Learned

- Deepened understanding of SwiftUI state & view lifecycle
- Working with `GeometryReader`, `DragGesture`, and `ScrollTargetBehavior`
- Creating clean animation loops and masking using `trim`, `.stroke`, and `overlay`
- Building MVVM architecture from scratch without tutorials
- Designing interactive scroll animations using geometry and scale math

---

## 📈 Next Features (Planned)

- 🧩 WidgetKit + Live Activity support
- 📦 Local storage & recipe favoriting
- 🔔 Timer background persistence & notifications
- 🔍 Improved accessibility & font scaling

---

## 👨‍💻 Author

**Youssef Ashraf**  
iOS Developer | Computer Science Student  
[GitHub](https://github.com/yousseeefashrraf) · [YouTube](https://youtube.com/@YooussefAshraf)

---

## ⚠️ Disclaimer

This app is a personal project. API content is fetched from dummyjson.com for demo purposes only.
