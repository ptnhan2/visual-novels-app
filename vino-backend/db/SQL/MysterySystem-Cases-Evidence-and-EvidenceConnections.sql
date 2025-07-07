-- Quản lý các vụ án
CREATE TABLE cases(
	id SERIAL PRIMARY KEY,
	story_id INTEGER REFERENCES stories(id),
	case_title TEXT NOT NULL,
	case_description TEXT,
	case_type TEXT, -- 'murder', 'disapearance', 'supernatural', 'theft'
	difficulty_level INTEGER DEFAULT 1,

	-- Trạng thái vụ án
	status TEXT DEFAULT 'open', -- 'open', 'investigating', 'solved', 'cold'
	solution_quality TEXT, -- 'perfect', 'good', 'partial', 'failed' 
	solved_at TIMESTAMP,

	-- Tiến độ 
	progress_percentage INTEGER DEFAULT 0,
	key_evidence_found INTEGER DEFAULT 0,
	key_evidence_required INTEGER DEFAULT 0
	
);

-- Bằng chứng và manh mối
CREATE TABLE evidence (
	id SERIAL PRIMARY KEY,
	case_id INTEGER REFERENCES cases(id),
	evidence_name TEXT NOT NULL,
	evidence_type TEXT NOT NULL,
	description TEXT,
	discovery_method TEXT, -- 'found', 'given', 'analyzed', 'supernatural_ability'
	
	-- Thuộc tính bằng chứng
	reliability_score INTEGER DEFAULT 100, -- 0 to 100
	is_key_evidence BOOLEAN DEFAULT FALSE,
	is_red_herring BOOLEAN DEFAULT FALSE,
	supernatural_origin BOOLEAN DEFAULT FALSE,
	
	-- Metadata
	image_path TEXT,
	discovery_scene_id INTEGER REFERENCES scenes(id),
	discovery_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Mối liên hệ giữa các bằng chứng
CREATE TABLE evidence_connection (
	id SERIAL PRIMARY KEY,
	evidence_1_id INTEGER REFERENCES evidence(id),
	evidence_2_id INTEGER REFERENCES evidence(id),
	connection_type TEXT, -- 'contradicts', 'supports', 'explains', 'leads_to'
	connection_strength INTEGER DEFAULT 50, -- 0 to 100
	discovered_by_player BOOLEAN DEFAULT FALSE
);



