CREATE TABLE stories (
	id SERIAL PRIMARY KEY,
	title TEXT NOT NULL,
	description TEXT,
	genre TEXT DEFAULT 'mystery_supernatural',
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE chapters (
	id SERIAL PRIMARY KEY,
	story_id INTEGER REFERENCES stories(id),  
	title TEXT NOT NULL,
	chapter_number INTEGER NOT NULL,
	description TEXT,
	unlock_conditions TEXT, --JSON Điều kiện mở khoá
	is_completed BOOLEAN DEFAULT FALSE
);

CREATE TABLE scenes (
	id SERIAL PRIMARY KEY,
	chapter_id INTEGER REFERENCES chapters(id),
	title TEXT NOT NULL,
	scene_type TEXT, --'dialogue', 'investigation', 'choice', 'cutscene'
	background_image TEXT, 
	background_music TEXT,
	order_index INTEGER NOT NULL,
	visit_count INTEGER DEFAULT 0,

	-- Điều kiện truy cập
	access_requirements TEXT, --JSON 
	is_repeatable BOOLEAN DEFAULT FALSE
);


