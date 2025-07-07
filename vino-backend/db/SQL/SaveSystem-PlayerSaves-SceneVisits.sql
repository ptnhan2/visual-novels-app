-- Save games
CREATE TABLE player_saves (
    id SERIAL PRIMARY KEY,
    player_name TEXT NOT NULL,
    save_slot INTEGER DEFAULT 1,

    -- Progress
    current_story_id INTEGER REFERENCES stories(id),
    current_chapter_id INTEGER REFERENCES chapters(id),
    current_scene_id INTEGER REFERENCES scenes(id),

    -- Time tracking
    total_playtime INTEGER DEFAULT 0, -- minutes
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_played TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Metadata
    save_description TEXT,
    screenshot_path TEXT,

    -- Flags
    is_auto_save BOOLEAN DEFAULT FALSE,
    is_chapter_complete BOOLEAN DEFAULT FALSE
);

-- Visited content tracking
CREATE TABLE scene_visits (
    id SERIAL PRIMARY KEY,
    save_id INTEGER REFERENCES player_saves(id),
    scene_id INTEGER REFERENCES scenes(id),
    visit_count INTEGER DEFAULT 0,
    first_visit TIMESTAMP,
    last_visit TIMESTAMP,

    -- Completion tracking
    dialogue_completed BOOLEAN DEFAULT FALSE,
    choices_made TEXT, -- JSON array of choice IDs
    evidence_found TEXT, -- JSON array of evidence IDs

    -- Performance
    investigation_quality INTEGER DEFAULT 0, -- 0-100
    time_spent_minutes INTEGER DEFAULT 0
);
