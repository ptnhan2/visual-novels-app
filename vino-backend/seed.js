const pool = require('./db');

async function seed() {
  try {
    // Create tables if not exist
    await pool.query(`
      CREATE TABLE IF NOT EXISTS scenes (
        id SERIAL PRIMARY KEY,
        content TEXT NOT NULL
      );

      CREATE TABLE IF NOT EXISTS choices (
        id SERIAL PRIMARY KEY,
        scene_id INTEGER REFERENCES scenes(id),
        text TEXT NOT NULL,
        next_scene_id INTEGER
      );
    `);

    // Clear old data
    await pool.query('DELETE FROM choices');
    await pool.query('DELETE FROM scenes');

    // Insert scenes
    const scene1 = await pool.query(
      `INSERT INTO scenes (content) VALUES ($1) RETURNING *`,
      ['You wake up in a mysterious forest.']
    );
    const scene2 = await pool.query(
      `INSERT INTO scenes (content) VALUES ($1) RETURNING *`,
      ['You follow the sound of water and find a river.']
    );
    const scene3 = await pool.query(
      `INSERT INTO scenes (content) VALUES ($1) RETURNING *`,
      ['You head into the dark cave and hear strange noises.']
    );

    // Insert choices for scene 1
    await pool.query(
      `INSERT INTO choices (scene_id, text, next_scene_id) VALUES
      ($1, $2, $3),
      ($1, $4, $5)`,
      [
        scene1.rows[0].id,
        'Follow the sound of water',
        scene2.rows[0].id,
        'Enter the dark cave',
        scene3.rows[0].id,
      ]
    );

    console.log('✅ Seeded scenes and choices successfully.');
    process.exit();
  } catch (err) {
    console.error('❌ Failed to seed data:', err);
    process.exit(1);
  }
}

seed();
