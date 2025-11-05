# Flutter API Integration Guide with Riverpod 🚀

## Welcome! This guide will help you understand API integration step by step using Riverpod

API integration can seem overwhelming at first, but once you understand the pattern, it becomes much easier. This guide breaks down the process into simple, digestible steps using **Riverpod** - a modern, robust state management solution.

---

## Table of Contents

1. [Understanding the Big Picture](#understanding-the-big-picture)
2. [Why Riverpod?](#why-riverpod)
3. [The 4 Key Pieces](#the-4-key-pieces)
4. [Step-by-Step Implementation](#step-by-step-implementation)
5. [Working Example: Login Flow](#working-example-login-flow)
6. [Common Pitfalls & Solutions](#common-pitfalls--solutions)
7. [Testing Your API Integration](#testing-your-api-integration)
8. [Next Steps](#next-steps)

---

## Understanding the Big Picture

### What is API Integration?

An API (Application Programming Interface) is a way for your Flutter app to communicate with a backend server. Think of it as a restaurant:

- **Your Flutter App** = Customer (requests food)
- **API** = Waiter (takes order, brings food)
- **Backend Server** = Kitchen (prepares the food)

### How it Works

```
User taps Login button
    ↓
Flutter app sends HTTP request (email + password)
    ↓
Backend server checks credentials
    ↓
Backend responds with user data + token
    ↓
Flutter app saves data and navigates to home screen
```

---

## Why Riverpod?

### What is Riverpod?

Riverpod is a complete rewrite of Provider (a popular state management solution). It fixes Provider's problems and adds powerful new features.

### Why Choose Riverpod Over Others?

**Compared to GetX:**
- ✅ **Compile-time safety** - Errors caught before running
- ✅ **No global state** - Everything is explicit
- ✅ **Better testing** - Easy to mock and test
- ✅ **No magic** - Clear, predictable behavior

**Compared to Provider:**
- ✅ **No BuildContext needed** - Access state anywhere
- ✅ **Compile-time safety** - Type-safe
- ✅ **Better performance** - More granular rebuilds

**Compared to Bloc:**
- ✅ **Less boilerplate** - Simpler to write
- ✅ **Easier to learn** - More intuitive API
- ✅ **Flexible** - Multiple patterns supported

### Key Riverpod Advantages

1. **Type-Safe**: Catches errors at compile time
2. **Testable**: Easy to write unit tests
3. **No Context Required**: Use anywhere in your code
4. **Composable**: Providers can depend on other providers
5. **DevTools**: Excellent debugging support

---

## The 4 Key Pieces

Every API integration needs these four components:

### 1. **Model** 📦
A class that represents your data structure.

**Why?** APIs send/receive JSON. Models convert JSON ↔ Dart objects.

**Example:**
```dart
class UserModel {
  final String id;
  final String email;

  // Convert JSON to Dart object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
    );
  }

  // Convert Dart object to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email};
  }
}
```

**Location in your project:** `lib/models/user_model.dart`

---

### 2. **Service** 🔧
A class that makes HTTP requests to your API.

**Why?** Keeps all API calls in one place, separate from UI code.

**Example:**
```dart
class AuthService {
  static const String _baseUrl = 'https://api.yourapp.com';

  Future<ApiResponse<UserModel>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final user = UserModel.fromJson(jsonDecode(response.body));
      return ApiResponse.success(data: user);
    } else {
      return ApiResponse.failure(error: 'Login failed');
    }
  }
}
```

**Location in your project:** `lib/services/auth_service.dart`

---

### 3. **Provider (State Notifier)** 🎮
Manages state using Riverpod's StateNotifier pattern.

**Why?** Handles loading states, errors, and coordinates between UI and Service.

**Example:**
```dart
// State class - represents current state
class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final UserModel? user;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });

  // Create new state with updated values
  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    UserModel? user,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }
}

// StateNotifier - manages the state
class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this._authService) : super(const LoginState());

  final AuthService _authService;

  Future<bool> login(String email, String password) async {
    // Update state to show loading
    state = state.copyWith(isLoading: true);

    // Call API
    final response = await _authService.login(email, password);

    if (response.success) {
      // Update state with user data
      state = state.copyWith(isLoading: false, user: response.data);
      return true;
    } else {
      // Update state with error
      state = state.copyWith(isLoading: false, errorMessage: response.error);
      return false;
    }
  }
}

// Provider - exposes the notifier
final loginStateProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return LoginNotifier(authService);
});
```

**Location in your project:** `lib/providers/auth_provider.dart`

---

### 4. **UI Screen (ConsumerWidget)** 🎨
Displays the interface and reacts to state changes.

**Why?** This is what the user sees and interacts with.

**Example:**
```dart
class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    // Call login method
    final success = await ref.read(loginStateProvider.notifier).login(
      _emailController.text,
      _passwordController.text,
    );

    if (success) {
      // Navigate to home
      Navigator.push(...);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch state for changes
    final loginState = ref.watch(loginStateProvider);

    return Scaffold(
      body: Column(
        children: [
          TextField(controller: _emailController),
          TextField(controller: _passwordController),
          ElevatedButton(
            onPressed: loginState.isLoading ? null : _handleLogin,
            child: loginState.isLoading
              ? CircularProgressIndicator()
              : Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

**Location in your project:** `lib/screens/features/login/login_screen.dart`

---

## Step-by-Step Implementation

### Step 0: Setup Riverpod

**Add dependencies to `pubspec.yaml`:**
```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  http: ^1.1.0
```

**Wrap your app with ProviderScope in `main.dart`:**
```dart
void main() {
  runApp(
    ProviderScope(  // This enables Riverpod
      child: MyApp(),
    ),
  );
}
```

**What is ProviderScope?**
- The root widget that enables Riverpod in your app
- ALL providers must be under a ProviderScope
- Think of it as the container that holds all your state

---

### Step 1: Create Your Model

**What it does:** Defines the structure of your data and handles JSON conversion.

**Files to create:**
- `lib/models/user_model.dart`
- `lib/models/api_response.dart`

**Key methods:**
- `fromJson()` - Convert API response to Dart object
- `toJson()` - Convert Dart object to send to API

**Example in your project:** Check `lib/models/user_model.dart`

---

### Step 2: Create Your Service

**What it does:** Makes HTTP requests to your backend API.

**File to create:** `lib/services/auth_service.dart`

**Steps:**
1. Define base URL
2. Define endpoints (`/auth/login`, `/auth/signup`, etc.)
3. Create methods for each API call
4. Handle responses and errors
5. Return standardized response objects

**HTTP Methods:**
- `GET` - Retrieve data (e.g., get user profile)
- `POST` - Send data (e.g., login, signup)
- `PUT` - Update data (e.g., update profile)
- `DELETE` - Remove data (e.g., delete account)

**Example in your project:** Check `lib/services/auth_service.dart`

---

### Step 3: Create Your State & Provider

**What it does:** Manages state using Riverpod's patterns.

**File to create:** `lib/providers/auth_provider.dart`

**Three parts:**

1. **State Class** - Immutable data representing current state
```dart
class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final UserModel? user;

  LoginState copyWith({...}) {...}
}
```

2. **StateNotifier** - Business logic that modifies state
```dart
class LoginNotifier extends StateNotifier<LoginState> {
  Future<bool> login(...) async {
    state = state.copyWith(isLoading: true);
    // ... call API ...
    state = state.copyWith(isLoading: false, user: userData);
  }
}
```

3. **Provider** - Makes notifier accessible throughout app
```dart
final loginStateProvider = StateNotifierProvider<LoginNotifier, LoginState>(...);
```

**Example in your project:** Check `lib/providers/auth_provider.dart`

---

### Step 4: Connect Your UI

**What it does:** Displays the form and reacts to provider state.

**File to update:** `lib/screens/features/login/login_screen.dart`

**Key concepts:**
- `ConsumerStatefulWidget` - Widget with Riverpod access
- `ref.watch(provider)` - Listen to provider and rebuild on changes
- `ref.read(provider)` - One-time access without listening
- Form validation with validators

**Example in your project:** Check `lib/screens/features/login/login_screen.dart`

---

## Understanding Riverpod Concepts

### ref.watch() vs ref.read()

**ref.watch()** - Subscribe and rebuild
```dart
// Use in build() method
final loginState = ref.watch(loginStateProvider);
// Widget rebuilds when loginState changes
```

**ref.read()** - One-time access
```dart
// Use in event handlers (onPressed, etc.)
ref.read(loginStateProvider.notifier).login(...);
// Doesn't cause rebuilds
```

### Provider Types in Riverpod

| Provider Type | When to Use | Example |
|--------------|-------------|---------|
| `Provider` | Objects that never change | Services, Repositories |
| `StateProvider` | Simple state (like a counter) | Theme mode, simple toggles |
| `StateNotifierProvider` | Complex state with logic | Login state, cart state |
| `FutureProvider` | Async data loaded once | User profile on app start |
| `StreamProvider` | Streams of data | Real-time updates |

### Understanding StateNotifierProvider

```dart
final loginStateProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});

// In your widget:
final loginState = ref.watch(loginStateProvider);        // Get STATE
ref.read(loginStateProvider.notifier).login(...);        // Call METHOD
```

**Two parts:**
1. `loginStateProvider` - Gives you the STATE (LoginState)
2. `loginStateProvider.notifier` - Gives you the NOTIFIER (LoginNotifier methods)

---

## Working Example: Login Flow

Let's trace through what happens when a user logs in with Riverpod:

### 1. User Interaction
```dart
// User enters email: "john@example.com"
// User enters password: "password123"
// User taps Login button
ElevatedButton(onPressed: _handleLogin)
```

### 2. Handler Calls Provider Method
```dart
Future<void> _handleLogin() async {
  // Call login on the notifier
  final success = await ref.read(loginStateProvider.notifier).login(
    email: _emailController.text,
    password: _passwordController.text,
  );

  if (success) {
    Navigator.push(...);
  }
}
```

### 3. StateNotifier Updates State
```dart
Future<bool> login(String email, String password) async {
  // Show loading
  state = state.copyWith(isLoading: true);

  // Call service
  final response = await _authService.login(email, password);

  // Update state with result
  if (response.success) {
    state = state.copyWith(isLoading: false, user: response.data);
    return true;
  } else {
    state = state.copyWith(isLoading: false, errorMessage: response.error);
    return false;
  }
}
```

### 4. Service Makes HTTP Request
```dart
final response = await http.post(
  Uri.parse('https://api.yourapp.com/auth/login'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({'email': 'john@example.com', 'password': 'password123'}),
);
```

### 5. Backend Sends Response
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "123",
      "username": "john_doe",
      "email": "john@example.com"
    }
  }
}
```

### 6. Service Processes Response
```dart
if (response.statusCode == 200) {
  final jsonResponse = jsonDecode(response.body);
  final user = UserModel.fromJson(jsonResponse['data']['user']);
  return ApiResponse.success(data: user);
}
```

### 7. UI Automatically Updates
```dart
// ref.watch() detects state change
final loginState = ref.watch(loginStateProvider);

// Widget rebuilds with new state
// Loading spinner disappears
// Success callback triggers navigation
```

**The Flow:**
```
User Action
  → ref.read().notifier.method()
  → Notifier updates state
  → ref.watch() rebuilds UI
```

---

## Common Pitfalls & Solutions

### Problem 1: "ProviderScope not found"

**Error message:** `No ProviderScope found`

**Cause:** App not wrapped with ProviderScope

**Solution:**
```dart
void main() {
  runApp(
    const ProviderScope(  // Add this!
      child: MyApp(),
    ),
  );
}
```

---

### Problem 2: "ref is not defined"

**Cause:** Using regular StatelessWidget/StatefulWidget instead of Consumer variants

**Solution:**
```dart
// Wrong:
class MyScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final state = ref.watch(provider);  // ERROR: ref doesn't exist
  }
}

// Correct:
class MyScreen extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);  // Works!
  }
}
```

---

### Problem 3: "Using ref.watch() in onPressed"

**Problem:** Using ref.watch() in event handlers causes unnecessary rebuilds

**Wrong:**
```dart
ElevatedButton(
  onPressed: () {
    ref.watch(provider).method();  // Wrong!
  },
)
```

**Correct:**
```dart
ElevatedButton(
  onPressed: () {
    ref.read(provider.notifier).method();  // Correct!
  },
)
```

**Rule:**
- `ref.watch()` in `build()` method
- `ref.read()` in event handlers

---

### Problem 4: "State not updating UI"

**Cause:** Forgetting to use copyWith() or not watching the provider

**Solution:**
```dart
// Wrong: Directly modifying state (doesn't work)
state.isLoading = true;

// Correct: Create new state with copyWith()
state = state.copyWith(isLoading: true);

// Also make sure you're watching the provider
final loginState = ref.watch(loginStateProvider);  // This is required!
```

---

### Problem 5: "Disposing providers"

**Question:** Do I need to dispose providers?

**Answer:** No! Riverpod automatically manages provider lifecycle.

---

## Testing Your API Integration

### Method 1: Use Real Backend API

1. Update base URL in `auth_service.dart`:
```dart
static const String _baseUrl = 'https://your-actual-api.com/api';
```

2. Run your app and try logging in

3. Check logs to see what's happening:
```bash
flutter run --verbose
```

---

### Method 2: Test with Postman First

Before integrating in Flutter, test your API with Postman:

1. Open Postman
2. Create POST request to: `https://your-api.com/api/auth/login`
3. Set Headers: `Content-Type: application/json`
4. Set Body (raw JSON):
```json
{
  "email": "test@example.com",
  "password": "password123"
}
```
5. Send request and examine response

---

### Method 3: Mock Provider for Testing

Riverpod makes testing easy with provider overrides:

```dart
testWidgets('Login test', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // Override with mock
        loginStateProvider.overrideWith((ref) => MockLoginNotifier()),
      ],
      child: MyApp(),
    ),
  );

  // Test your widget...
});
```

---

## Next Steps

### What You've Learned ✅
- Riverpod state management fundamentals
- StateNotifier pattern
- Provider types and when to use them
- ref.watch() vs ref.read()
- Model classes and JSON serialization
- HTTP requests and response handling
- Loading and error states
- Form validation

### Practice Exercises 💪

#### Exercise 1: Implement Signup
Apply the same pattern to the signup screen:
1. Create `SignupState` class
2. Create `SignupNotifier` extending StateNotifier
3. Create `signupStateProvider`
4. Update signup screen to use ConsumerStatefulWidget
5. Call `authService.signup()` method

#### Exercise 2: Fetch User Profile
Create a GET request to fetch user data:
1. Add `getUserProfile()` method in `AuthService`
2. Create `profileStateProvider` using FutureProvider
3. Display data in profile screen using ref.watch()

#### Exercise 3: Update User Profile
Create a PUT request to update user data:
1. Add `updateProfile()` method in `AuthService`
2. Create `ProfileNotifier` with update method
3. Create form for editing profile
4. Update local storage with new data

---

## Riverpod Best Practices

### 1. Keep State Immutable
```dart
// Always use copyWith()
state = state.copyWith(isLoading: true);

// Never modify state directly
state.isLoading = true;  // Wrong!
```

### 2. Separate Concerns
- **Models** - Data structure only
- **Services** - API calls only
- **Providers** - State management only
- **Widgets** - UI only

### 3. Use Appropriate Provider Types
- Simple state? Use `StateProvider`
- Complex state with logic? Use `StateNotifierProvider`
- Async data? Use `FutureProvider` or `StreamProvider`

### 4. Watch Selectively for Performance
```dart
// Watch entire state (rebuilds on any change)
final state = ref.watch(loginStateProvider);

// Watch specific field (rebuilds only when isLoading changes)
final isLoading = ref.watch(
  loginStateProvider.select((state) => state.isLoading)
);
```

### 5. Use ref.listen() for Side Effects
```dart
// Show snackbar when error occurs
ref.listen(loginStateProvider, (previous, next) {
  if (next.errorMessage != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.errorMessage!)),
    );
  }
});
```

---

## Resources

### Documentation
- [Riverpod Official Docs](https://riverpod.dev)
- [Flutter HTTP Package](https://pub.dev/packages/http)
- [JSON Serialization Guide](https://docs.flutter.dev/data-and-backend/json)

### Your Project Structure
```
lib/
├── models/              ← Data structures
│   ├── user_model.dart
│   └── api_response.dart
├── services/            ← API calls
│   └── auth_service.dart
├── providers/           ← Riverpod state management
│   └── auth_provider.dart
└── screens/            ← UI
    └── features/
        └── login/
            └── login_screen.dart
```

---

## Final Tips 🎯

1. **Start Simple** - Get one provider working first, then expand
2. **Use Logs** - Always log requests and responses during development
3. **Test Incrementally** - Test each piece separately
4. **Keep It Clean** - Separate concerns (Model, Service, Provider, UI)
5. **Read Error Messages** - They tell you exactly what's wrong
6. **Use DevTools** - Riverpod has excellent debugging tools
7. **Embrace Immutability** - Always use copyWith()
8. **Think in Providers** - Break your app into small, composable providers

---

## Riverpod vs Other Solutions

| Feature | Riverpod | GetX | Bloc | Provider |
|---------|----------|------|------|----------|
| Compile-time safety | ✅ | ❌ | ✅ | ❌ |
| No BuildContext | ✅ | ✅ | ❌ | ❌ |
| Easy to test | ✅ | ❌ | ✅ | ⚠️ |
| Boilerplate | Low | Low | High | Medium |
| Learning curve | Medium | Low | High | Low |
| DevTools | ✅ | ⚠️ | ✅ | ✅ |
| Type safety | ✅ | ❌ | ✅ | ⚠️ |

---

**Remember:** API integration with Riverpod becomes natural with practice. Focus on understanding the flow: Model → Service → Provider → UI. Once you get this pattern, you can apply it to any feature!

Good luck! 🚀
