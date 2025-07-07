const pool = require('../db');

exports.getAllScenes = async () => {
    const result = await pool.query('SELECT * FROM scenes');
    return result.rows; 
}

exports.getSceneById = async (id) => {
    const result = await pool.query('SELECT * FROM scenes WHERE id = $1', [id]); 
    return result.rows[0];
}

exports.createScene = async (content) => {
  const result = await pool.query(
    'INSERT INTO scenes (content) VALUES ($1) RETURNING *',
    [content]
  );
  return result.rows[0];
};

exports.updateScene = async (id, content) => {
  const result = await pool.query(
    'UPDATE scenes SET content = $1 WHERE id = $2 RETURNING *',
    [content, id]
  );
  return result.rows[0];
};

exports.deleteScene = async (id) => {
  await pool.query('DELETE FROM scenes WHERE id = $1', [id]);
};