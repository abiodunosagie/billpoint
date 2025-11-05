# Flutter API Integration Guide 🚀

## Welcome! This guide will help you understand API integration step by step.

API integration can seem overwhelming at first, but once you understand the pattern, it becomes much easier. This guide breaks down the process into simple, digestible steps.

---

## Table of Contents

1. [Understanding the Big Picture](#understanding-the-big-picture)
2. [The 4 Key Pieces](#the-4-key-pieces)
3. [Step-by-Step Implementation](#step-by-step-implementation)
4. [Working Example: Login Flow](#working-example-login-flow)
5. [Common Pitfalls & Solutions](#common-pitfalls--solutions)
6. [Testing Your API Integration](#testing-your-api-integration)
7. [Next Steps](#next-steps)

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

### 3. **Controller** 🎮
Manages state and coordinates between UI and Service.

**Why?** Handles loading states, errors, and navigation. Keeps UI code clean.

**Example:**
```dart
class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  final RxBool isLoading = false.obs;

  Future<void> login() async {
    isLoading.value = true; // Show loading spinner

    final response = await _authService.login(email, password);

    if (response.success) {
      Get.snackbar('Success', 'Login successful');
      Get.offAllNamed('/home');
    } else {
      Get.snackbar('Error', response.error);
    }

    isLoading.value = false; // Hide loading spinner
  }
}
```

**Location in your project:** `lib/controllers/login_controller.dart`

---

### 4. **UI Screen** 🎨
Displays the interface and reacts to state changes.

**Why?** This is what the user sees and interacts with.

**Example:**
```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Obx(() => ElevatedButton(
      onPressed: controller.isLoading.value ? null : controller.login,
      child: controller.isLoading.value
        ? CircularProgressIndicator()
        : Text('Login'),
    ));
  }
}
```

**Location in your project:** `lib/screens/features/login/login_screen.dart`

---

## Step-by-Step Implementation

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

### Step 3: Create Your Controller

**What it does:** Manages state and orchestrates the login flow.

**File to create:** `lib/controllers/login_controller.dart`

**Responsibilities:**
- Store form controllers (email, password)
- Manage loading states
- Call service methods
- Handle success/error responses
- Navigate to next screen
- Save data to local storage

**GetX Reactive Variables:**
```dart
final RxBool isLoading = false.obs;  // Automatically updates UI
final RxString errorMessage = ''.obs;
```

**Example in your project:** Check `lib/controllers/login_controller.dart`

---

### Step 4: Connect Your UI

**What it does:** Displays the form and reacts to controller state.

**File to update:** `lib/screens/features/login/login_screen.dart`

**Key concepts:**
- `Get.put()` - Initialize controller
- `Obx()` - Watch reactive variables
- `TextFormField` - Input fields with validation
- Form validation with `formKey`

**Example in your project:** Check `lib/screens/features/login/login_screen.dart`

---

## Working Example: Login Flow

Let's trace through what happens when a user logs in:

### 1. User Interaction
```dart
// User enters email: "john@example.com"
// User enters password: "password123"
// User taps Login button
ElevatedButton(onPressed: controller.login)
```

### 2. Controller Method Called
```dart
Future<void> login() async {
  // Validate form
  if (!formKey.currentState!.validate()) return;

  // Show loading
  isLoading.value = true;  // UI shows spinner

  // Call service
  final response = await _authService.login(
    email: emailController.text,
    password: passwordController.text,
  );

  // Handle response...
}
```

### 3. Service Makes HTTP Request
```dart
// Prepare request
final response = await http.post(
  Uri.parse('https://api.yourapp.com/auth/login'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'email': 'john@example.com',
    'password': 'password123',
  }),
);
```

### 4. Backend Processes Request
```
Backend checks database:
- Does user exist?
- Is password correct?
- Generate authentication token
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

### 7. Controller Handles Response
```dart
if (response.success) {
  // Save user data
  await _localStorage.saveData('user', user.toJson());

  // Show success message
  Get.snackbar('Success', 'Login successful');

  // Navigate to home
  Get.offAllNamed('/home');
}
```

### 8. UI Updates
```dart
// isLoading becomes false
isLoading.value = false;

// Obx() widgets rebuild
// Loading spinner disappears
// Navigation happens
```

---

## Common Pitfalls & Solutions

### Problem 1: "I don't see any response from my API"

**Possible causes:**
- Wrong API URL
- Backend not running
- Network connectivity issues

**Solution:**
1. Check logs: `TLoggerHelper` will show request/response details
2. Verify API URL is correct
3. Test API with Postman or curl first
4. Check `response.statusCode` and `response.body`

**Debug code:**
```dart
print('Status code: ${response.statusCode}');
print('Response body: ${response.body}');
```

---

### Problem 2: "JSON parsing error"

**Error message:** `type 'Null' is not a subtype of type 'String'`

**Cause:** API response structure doesn't match your model.

**Solution:**
1. Print the actual API response: `print(response.body)`
2. Compare it with your model's `fromJson()` method
3. Update model to match actual response structure
4. Use null-safe operators (`??`) for optional fields

**Example:**
```dart
// If API might not return 'phoneNumber'
phoneNumber: json['phoneNumber'] ?? json['phone'] ?? '',
```

---

### Problem 3: "UI doesn't update"

**Cause:** Not using reactive variables or Obx() widget.

**Solution:**
1. Ensure variables use `.obs`: `final RxBool isLoading = false.obs;`
2. Wrap widgets with `Obx(() => ...)` to watch reactive variables
3. Update values with `.value`: `isLoading.value = true;`

**Wrong:**
```dart
// Won't trigger rebuild
bool isLoading = false;
isLoading = true;
```

**Correct:**
```dart
// Triggers rebuild automatically
final RxBool isLoading = false.obs;
isLoading.value = true;
```

---

### Problem 4: "401 Unauthorized error"

**Cause:** Missing or invalid authentication token.

**Solution:**
1. Save token when user logs in: `localStorage.saveData('token', token)`
2. Include token in subsequent requests:
```dart
headers: {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json',
}
```

---

### Problem 5: "CORS error" (when testing on web)

**Cause:** Browser security policy blocking requests.

**Solution:**
1. Backend must enable CORS
2. For development, run Flutter web with: `flutter run -d chrome --web-browser-flag "--disable-web-security"`
3. Contact your backend developer to configure CORS properly

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
3. Set Headers:
   - `Content-Type: application/json`
4. Set Body (raw JSON):
```json
{
  "email": "test@example.com",
  "password": "password123"
}
```
5. Send request and examine response
6. Make sure it returns 200 status code

---

### Method 3: Use Mock Data (for learning)

Create a fake service for testing without a backend:

```dart
class MockAuthService {
  Future<ApiResponse<UserModel>> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Simulate successful login
    if (email == "test@example.com" && password == "password") {
      final user = UserModel(
        id: '123',
        username: 'test_user',
        email: email,
      );
      return ApiResponse.success(data: user);
    } else {
      return ApiResponse.failure(error: 'Invalid credentials');
    }
  }
}
```

---

## Next Steps

### What You've Learned ✅
- Model classes and JSON serialization
- HTTP requests and response handling
- State management with GetX
- Loading and error states
- Form validation
- Local storage for persistent data

### Practice Exercises 💪

#### Exercise 1: Implement Signup
Apply the same pattern to the signup screen:
1. Create `SignupController` (similar to `LoginController`)
2. Update `signup_screen.dart` to use the controller
3. Call `authService.signup()` method
4. Handle success/error responses

#### Exercise 2: Fetch User Profile
Create a GET request to fetch user data:
1. Add `getUserProfile()` method in `AuthService`
2. Create `ProfileController`
3. Display data in `profile_screen.dart`

#### Exercise 3: Update User Profile
Create a PUT request to update user data:
1. Add `updateProfile()` method in `AuthService`
2. Create form for editing profile
3. Send updated data to API
4. Update local storage with new data

---

### Handling More Complex Scenarios

#### Working with Lists
```dart
// Model
class Product {
  final String id;
  final String name;
  final double price;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }
}

// Service
Future<List<Product>> getProducts() async {
  final response = await http.get(Uri.parse('$_baseUrl/products'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Product.fromJson(json)).toList();
  }
  throw Exception('Failed to load products');
}
```

#### File Uploads
```dart
Future<ApiResponse<String>> uploadProfileImage(File imageFile) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$_baseUrl/upload'),
  );

  request.files.add(
    await http.MultipartFile.fromPath('image', imageFile.path),
  );

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return ApiResponse.success(data: jsonResponse['url']);
  }
  return ApiResponse.failure(error: 'Upload failed');
}
```

---

## Resources

### Documentation
- [Flutter HTTP Package](https://pub.dev/packages/http)
- [GetX State Management](https://pub.dev/packages/get)
- [JSON Serialization Guide](https://docs.flutter.dev/data-and-backend/json)

### Tools
- **Postman** - Test APIs before integrating
- **JSONFormatter** - Format and validate JSON
- **Flutter DevTools** - Debug network requests

### Your Project Structure
```
lib/
├── models/              ← Data structures
│   ├── user_model.dart
│   └── api_response.dart
├── services/            ← API calls
│   └── auth_service.dart
├── controllers/         ← State management
│   └── login_controller.dart
└── screens/            ← UI
    └── features/
        └── login/
            └── login_screen.dart
```

---

## Final Tips 🎯

1. **Start Simple** - Get one API call working first, then expand
2. **Use Logs** - Always log requests and responses during development
3. **Handle Errors** - Always assume the API might fail or return unexpected data
4. **Test Incrementally** - Test each piece separately before putting it all together
5. **Keep It Clean** - Separate concerns (Model, Service, Controller, UI)
6. **Read Error Messages** - They usually tell you exactly what's wrong
7. **Use Mock Data** - Don't wait for backend to be ready
8. **Ask Questions** - The Flutter community is very helpful!

---

## Need Help?

If you get stuck:
1. Check the comments in the code files
2. Look at the example implementation in `login_screen.dart`
3. Print debug information: `print()` and `TLoggerHelper.debug()`
4. Test API with Postman to isolate the issue
5. Read the error message carefully - it often tells you exactly what's wrong

---

**Remember:** API integration is a skill that gets easier with practice. Don't try to understand everything at once. Focus on one piece at a time, and gradually it will all make sense!

Good luck! 🚀
