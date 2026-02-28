const User = require('../models/User');

class UserService {
  // Create a new user
  async createUser(userData) {
    try {
      // Validate required fields
      if (!userData.username || !userData.email) {
        throw new Error('Username and email are required');
      }

      // Email validation
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(userData.email)) {
        throw new Error('Invalid email format');
      }

      const user = await User.create(userData);
      return {
        success: true,
        data: user,
        message: 'User created successfully'
      };
    } catch (err) {
      return {
        success: false,
        error: err.message
      };
    }
  }

  // Get all users
  async getAllUsers() {
    try {
      const users = await User.findAll();
      return {
        success: true,
        data: users,
        count: users.length
      };
    } catch (err) {
      return {
        success: false,
        error: err.message
      };
    }
  }

  // Get user by ID
  async getUserById(id) {
    try {
      const user = await User.findById(id);
      
      if (!user) {
        throw new Error('User not found');
      }

      return {
        success: true,
        data: user
      };
    } catch (err) {
      return {
        success: false,
        error: err.message
      };
    }
  }

  // Update user
  async updateUser(id, userData) {
    try {
      // Email validation if email is being updated
      if (userData.email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(userData.email)) {
          throw new Error('Invalid email format');
        }
      }

      const user = await User.update(id, userData);
      
      if (!user) {
        throw new Error('User not found');
      }

      return {
        success: true,
        data: user,
        message: 'User updated successfully'
      };
    } catch (err) {
      return {
        success: false,
        error: err.message
      };
    }
  }

  // Delete user
  async deleteUser(id) {
    try {
      const user = await User.delete(id);
      
      if (!user) {
        throw new Error('User not found');
      }

      return {
        success: true,
        data: user,
        message: 'User deleted successfully'
      };
    } catch (err) {
      return {
        success: false,
        error: err.message
      };
    }
  }
}

module.exports = new UserService();
