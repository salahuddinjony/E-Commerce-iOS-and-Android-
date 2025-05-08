import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _LoginSignUpScreenState createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<SignUpScreen> {
  bool isLoginSelected =
  true; // Tracks whether Login or SignUp form is displayed

  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Toggle password visibility
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.createAccount,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Log In / Sign Up Tab
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isLoginSelected = true;
                    });
                  },
                  child: Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isLoginSelected ? Colors.teal : Colors.grey,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isLoginSelected = false;
                    });
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 20,
                      color: !isLoginSelected ? Colors.teal : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Show Login Form if Login is selected
            if (isLoginSelected) ...[
              _buildEmailField(),
              SizedBox(height: 20),
              _buildPasswordField(),
              SizedBox(height: 10),
              _buildForgotPassword(),
              SizedBox(height: 20),
              _buildContinueButton(onPressed: _handleLogin),
            ],

            // Show Sign Up Form if Sign Up is selected
            if (!isLoginSelected) ...[
              _buildEmailField(),
              SizedBox(height: 20),
              _buildPasswordField(),
              SizedBox(height: 20),
              _buildConfirmPasswordField(),
              SizedBox(height: 20),
              _buildContinueButton(onPressed: _handleSignUp),
            ],
          ],
        ),
      ),
    );
  }

  // Method to build email input field
  Widget _buildEmailField() {
    return TextField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: 'Your Email',
        hintText: 'Enter your email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
    );
  }

  // Method to build password input field
  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  // Method to build confirm password field for Sign Up
  Widget _buildConfirmPasswordField() {
    return TextField(
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: 'Confirm your password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  // Method to build forgot password link
  Widget _buildForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            // Handle forgot password logic here
          },
          child: Text(
            'Forgot password?',
            style: TextStyle(fontSize: 14, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  // Method to build the continue button
  Widget _buildContinueButton({required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Center(
        child: Text(
          'Continue',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // Handle login logic
  void _handleLogin() {
    // Login logic goes here
    print("Login clicked");
  }

  // Handle sign-up logic
  void _handleSignUp() {
    // Sign-up logic goes here
    print("Sign up clicked");
  }
}
