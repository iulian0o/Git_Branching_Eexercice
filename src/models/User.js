const db = require('../config/database');

class User {
  // Create a new user
  static async create(userData) {
    const { username, email, full_name } = userData;
    const query = `
      INSERT INTO users (username, email, full_name)
      VALUES ($1, $2, $3)
      RETURNING *
    `;
    const values = [username, email, full_name];
    
    try {
      const result = await db.query(query, values);
      return result.rows[0];
    } catch (err) {
      throw err;
    }
  }

  // Get all users
  static async findAll() {
    const query = 'SELECT * FROM users ORDER BY created_at DESC';
    
    try {
      const result = await db.query(query);
      return result.rows;
    } catch (err) {
      throw err;
    }
  }

  // Get user by ID
  static async findById(id) {
    const query = 'SELECT * FROM users WHERE id = $1';
    
    try {
      const result = await db.query(query, [id]);
      return result.rows[0];
    } catch (err) {
      throw err;
    }
  }

  // Update user by ID
  static async update(id, userData) {
    const { username, email, full_name } = userData;
    const query = `
      UPDATE users 
      SET username = COALESCE($1, username),
          email = COALESCE($2, email),
          full_name = COALESCE($3, full_name),
          updated_at = CURRENT_TIMESTAMP
      WHERE id = $4
      RETURNING *
    `;
    const values = [username, email, full_name, id];
    
    try {
      const result = await db.query(query, values);
      return result.rows[0];
    } catch (err) {
      throw err;
    }
  }

  // Delete user by ID
  static async delete(id) {
    const query = 'DELETE FROM users WHERE id = $1 RETURNING *';
    
    try {
      const result = await db.query(query, [id]);
      return result.rows[0];
    } catch (err) {
      throw err;
    }
  }
}

module.exports = User;
