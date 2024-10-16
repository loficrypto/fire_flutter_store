# Project Overview
## User Experience

- Home Page: The starting point where users can see featured products, get an overview of the platform, and navigate to different sections.

- Shop Page: A dedicated page displaying all products in a grid layout, allowing users to browse and add items to their cart.

- Product Details: Provides detailed information about individual products, including images, descriptions, and prices.

- Cart: Allows users to view and manage the items they intend to purchase.

- Checkout: Processes the purchase, utilizing the user's wallet balance for transactions.

## User Profile Management

- Profile Details: Displays user information such as email and personal details.

- Wallet Balance: Shows the current balance and allows users to top up their wallet using cryptocurrency (USDT, BTC, LTC).

- Purchase History: Lists recent purchases with download links for digital products.

- Top-Up History: Records all wallet top-up transactions.

- Transactions: Displays all user transactions, both purchases and top-ups.

## Admin Panel

- Manage Orders: Admins can view and manage all orders placed by users.

- Manage Products: Admins can add new products, update existing ones, or delete products. Product management includes handling product images and files stored in Firebase Storage.

- Manage Users: Admins can view and manage all registered users.

- Send Emails: Admins can send email notifications to users using Brevo's SMTP.

## Automated Email Notifications

- Order Confirmation: Sends an email with product download links upon successful purchase. This ensures users receive their digital products directly in their inbox.

## Blog

- Posts Management: Admins can create, update, or delete blog posts. Posts can include images that are stored in Firebase Storage.

- User Engagement: Users can view and read blog posts, enhancing their interaction with the platform.

## Key Technologies and Integrations
- Flutter: Provides a responsive and modern web application.

## Firebase:

- Authentication: Manages user sign-up, sign-in, and authentication states.

- Firestore: A NoSQL database for storing and syncing user data, product details, orders, and blog posts.

- Storage: For storing and retrieving product files and blog images.

- Brevo's SMTP: Integrated with Nodemailer for sending automated email notifications.

- Apirone API: Handles cryptocurrency transactions for wallet top-ups.

### Project Structure
```
lib/
├── models/
│   ├── product.dart
│   ├── user.dart
├── services/
│   ├── firebase_auth_service.dart
│   ├── firestore_service.dart
│   ├── storage_service.dart
│   ├── email_service.dart
│   ├── payment_service.dart
├── views/
│   ├── home_view.dart
│   ├── shop_view.dart
│   ├── product_detail_view.dart
│   ├── cart_view.dart
│   ├── checkout_view.dart
│   ├── profile_view.dart
│   ├── admin_view.dart
│   ├── blog_view.dart
├── widgets/
│   ├── product_card.dart
│   ├── product_grid.dart
│   ├── profile_details.dart
│   ├── purchase_history.dart
│   ├── wallet_balance.dart
│   ├── transactions.dart
│   ├── admin_orders.dart
│   ├── admin_products.dart
│   ├── admin_users.dart
│   ├── admin_emails.dart
│   ├── admin_product_form.dart
├── main.dart
```

## Firestore Structure:

```
Firestore Database
|
├── users (collection)
|   ├── {userId} (document)
|       ├── email: string
|       ├── walletBalance: number
|       ├── purchases: array
|       ├── topUps: array
|       ├── transactions: array
|
├── products (collection)
|   ├── {productId} (document)
|       ├── name: string
|       ├── description: string
|       ├── price: number
|       ├── imageUrl: string
|       ├── productFile: string
|
├── orders (collection)
|   ├── {orderId} (document)
|       ├── userId: string
|       ├── items: array
|       ├── totalAmount: number
|       ├── date: string
|
├── blogPosts (collection)
|   ├── {postId} (document)
|       ├── title: string
|       ├── content: string
|       ├── imageUrl: string

```

### `firebase/firestore.rules`

```
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth.token.admin == true;
    }
    match /orders/{orderId} {
      allow read, write: if request.auth != null;
    }
    match /transactions/{transactionId} {
      allow read, write: if request.auth != null;
    }
    match /blogPosts/{postId} {
      allow read: if true;
      allow write: if request.auth.token.admin == true;
    }
  }
}

```
