-- Địa điểm điều tra
CREATE TABLE locations (
	id SERIAL PRIMARY KEY,
	case_id INTEGER REFERENCES cases(id),
	location_name TEXT NOT NULL,
	location_type TEXT, -- 'crime_scene', 'secondary_scene', 'interview_room', 'office'
	description TEXT,

	-- Hình ảnh
	background_image TEXT, 
	layout_map TEXT, -- đường dẫn đến map layout

	-- Trạng thái truy cập
	is_accessible BOOLEAN DEFAULT TRUE,
	access_requirements TEXT, --JSON
	visit_count INTEGER DEFAULT 0,

	-- Thuộc tính đặc biệt
	supernatural_activity_level INTEGER DEFAULT 0, -- 0 to 10
	danger_level INTEGER DEFAULT 0, -- 0 to 10
	evidence_remaining INTEGER DEFAULT 0
	
);

-- Điểm có thể điều tra trong location

CREATE TABLE investigation_points (
	id SERIAL PRIMARY KEY,
	location_id INTEGER REFERENCES locations(id),
	point_name TEXT NOT NULL,
	point_type TEXT, -- 'examine', 'search', 'interact', 'supernatural_sense'

	-- Vị trí trên màn hình
	x_coordinate INTEGER, 
	y_coordinate INTEGER,
	clickable_area TEXT, -- JSON định nghĩa vùng click

	-- Điều kiện
	requires_tool TEXT, -- 'magnifying_glass', 'fingerprint_kit', 'spirit_detector',...
	required_skill_level INTEGER DEFAULT 1,

	-- Kết quả
	evidence_found_id INTEGER REFERENCES evidence(id),
	information_gained TEXT, 

	-- Trạng thái
	is_examined BOOLEAN DEFAULT FALSE,
	examination_count INTEGER DEFAULT 0,
	max_examinations INTEGER DEFAULT 1
);