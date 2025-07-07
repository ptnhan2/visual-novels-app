-- Định nghĩa các loại kỹ năng
CREATE TABLE skill_definitions (
	id SERIAL PRIMARY KEY,
	skill_name TEXT NOT NULL UNIQUE,
	skill_category TEXT NOT NULL, -- 'investigation', 'supernatural', 'social', 'physical', 'mental'
	description TEXT,

	-- Cấu hình kỹ năng
	max_level INTEGER DEFAULT 100,
	base_exp_requirement INTEGER DEFAULT 100,
	exp_scaling_factor REAL DEFAULT 1.2,

	-- Điều kiện unlock
	is_starter_skill BOOLEAN DEFAULT FALSE,
	required_level INTEGER DEFAULT 1, 
	prerequisite_skill TEXT, -- JSON array of requiered skill IDs
	unlock_condition TEXT, -- JSON describing unlock requirements

	-- Visual & UI
	icon_path TEXT,
	color_code TEXT,
	sort_order INTEGER DEFAULT 0,

	-- Metadata
	is_active BOOLEAN DEFAULT TRUE,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 	
);


-- Bảng skill trees/dependencies
CREATE TABLE skill_dependencies (
	id SERIAL PRIMARY KEY, 
	skill_id INTEGER REFERENCES skill_definitions(id),
	required_skill_id INTEGER REFERENCES skill_definitions(id),
	required_level INTEGER DEFAULT 1,

	UNIQUE(skill_id, required_skill_id)
);

-- Bảng các bonus/synergy giữa skills
CREATE TABLE skill_synergies (
	id SERIAL PRIMARY KEY,
	primary_skill_id INTEGER REFERENCES skill_definitions(id),
    secondary_skill_id INTEGER REFERENCES skill_definitions(id),
    synergy_type TEXT, -- 'multiplicative', 'additive', 'unlock_action'
    bonus_formula TEXT, -- JSON describing how bonus is calculated
    description TEXT,
	UNIQUE(primary_skill_id, secondary_skill_id)
);

-- Bảng lịch sử sử dụng kỹ năng
CREATE TABLE skill_usage_history (
    id INTEGER PRIMARY KEY,
    save_id INTEGER REFERENCES player_saves(id),
    skill_id INTEGER REFERENCES skill_definitions(id),
    
    -- Context
    usage_context TEXT, -- 'investigation', 'dialogue', 'case_solving', 'random_event'
    case_id INTEGER REFERENCES cases(id),
    difficulty_level INTEGER DEFAULT 1,
    
    -- Results
    success_level INTEGER, -- 0-100
    exp_gained INTEGER DEFAULT 0,
    
    -- Modifiers that affected this usage
    applied_bonuses TEXT, -- JSON
    
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng skill categories để group skills
CREATE TABLE skill_categories (
    id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL UNIQUE,
    description TEXT,
    icon_path TEXT,
    color_theme TEXT,
    sort_order INTEGER DEFAULT 0,
    
    -- Category-wide bonuses
    category_bonus_formula TEXT, -- JSON for category mastery bonuses
    
    is_active BOOLEAN DEFAULT TRUE
);



































