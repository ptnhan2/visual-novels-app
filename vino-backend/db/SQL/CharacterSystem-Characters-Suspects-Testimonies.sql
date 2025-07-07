-- Nhân vật cơ bản
CREATE TABLE character (
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	description TEXT, 
	character_type TEXT, -- 'protagonist', 'suspect', 'witness', 'victim', 'npc'

	-- Hình ảnh và âm thanh
	sprite_path TEXT,
	voice_actor TEXT,

	-- Thuộc tính tính cách
	personality_traits TEXT, -- JSON
	background_story TEXT,

	-- Trạng thái
	is_alive BOOLEAN DEFAULT TRUE,
	current_location_id INTEGER REFERENCES locations(id),
	supernatural_connection BOOLEAN DEFAULT FALSE
);

-- Nghi can trong vụ án
CREATE TABLE suspects (
	id SERIAL PRIMARY KEY,
	character_id INTEGER REFERENCES character(id),
	case_id INTEGER REFERENCES cases(id),

	-- Vai trò trong vụ án
	suspect_type TEXT, -- 'primary', 'secondary', 'victim', 'expert'

	-- Thông tin điều tra
	alibi TEXT,
	motive TEXT,
	means_available TEXT, -- phương tiện thực hiện
	opportunity_window TEXT, -- Thời gian có cơ hội

	-- Đánh giá
	suspicion_level INTEGER DEFAULT 0, -- 0 to 100
	credibility_score INTEGER DEFAULT 0, -- 0 to 100

	-- Trạng thái
	is_eliminated BOOLEAN DEFAULT FALSE,
	elimination_reason TEXT,
	investigation_status TEXT DEFAULT 'not_interviewed'
);

-- Lời khai và phỏng vấn
CREATE TABLE testimonies (
	id SERIAL PRIMARY KEY,
	suspect_id INTEGER REFERENCES suspects(id),
	scene_id INTEGER REFERENCES scenes(id),

	-- Nội dung lời khai
	testimony_text TEXT NOT NULL,
	testimony_type TEXT, -- 'initial', 'follow_up', 'confrontation', 'breakdown'

	-- Độ tin cậy
	is_truthful BOOLEAN,
	partial_truth BOOLEAN DEFAULT FALSE,
	contradicts_evidence_id INTEGER REFERENCES evidence(id),

	-- Metadata
	given_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	interviewer_skill_level INTEGER DEFAULT 1
);

















































