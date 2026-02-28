const userService = require('../services/userService');

class UserController {
  // Create a new user
  async create(req, res) {
    try {
      const result = await userService.createUser(req.body);
      
      if (result.success) {
        return res.status(201).json(result);
      } else {
        return res.status(400).json(result);
      }
    } catch (err) {
      return res.status(500).json({
        success: false,
        error: 'Internal server error'
      });
    }
  }

  // Get all users
  async getAll(req, res) {
    try {
      const result = await userService.getAllUsers();
      
      if (result.success) {
        return res.status(200).json(result);
      } else {
        return res.status(500).json(result);
      }
    } catch (err) {
      return res.status(500).json({
        success: false,
        error: 'Internal server error'
      });
    }
  }

  // Get user by ID
  async getById(req, res) {
    try {
      const { id } = req.params;
      const result = await userService.getUserById(id);
      
      if (result.success) {
        return res.status(200).json(result);
      } else {
        return res.status(404).json(result);
      }
    } catch (err) {
      return res.status(500).json({
        success: false,
        error: 'Internal server error'
      });
    }
  }

  // Update user
  async update(req, res) {
    try {
      const { id } = req.params;
      const result = await userService.updateUser(id, req.body);
      
      if (result.success) {
        return res.status(200).json(result);
      } else {
        return res.status(404).json(result);
      }
    } catch (err) {
      return res.status(500).json({
        success: false,
        error: 'Internal server error'
      });
    }
  }

  // Delete user
  async delete(req, res) {
    try {
      const { id } = req.params;
      const result = await userService.deleteUser(id);
      
      if (result.success) {
        return res.status(200).json(result);
      } else {
        return res.status(404).json(result);
      }
    } catch (err) {
      return res.status(500).json({
        success: false,
        error: 'Internal server error'
      });
    }
  }
}

module.exports = new UserController();
