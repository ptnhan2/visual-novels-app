-- ##################################################################
-- #  DATABASE SCHEMA FOR A SUPERNATURAL MYSTERY VISUAL NOVEL       #
-- #  Optimized for Simplicity & PostgreSQL                       #
-- ##################################################################

-- Xóa các bảng cũ nếu tồn tại để chạy lại script một cách an toàn
DROP TABLE IF EXISTS scene_choices, dialogue_entries, investigation_points, supernatural_events, scenes, evidence, cases, chapters, stories, characters, player_saves CASCADE;

-- =========== 1. CORE STRUCTURE (Cấu trúc cốt lõi) =================
-- Lưu trữ thông tin về toàn bộ game hoặc các phần game lớn (nếu có phần mở rộng).
CREATE TABLE stories (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Phân chia câu chuyện thành các chương lớn.
CREATE TABLE chapters (
    id SERIAL PRIMARY KEY,
    story_id INTEGER NOT NULL REFERENCES stories(id),
    chapter_number INTEGER NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    -- Điều kiện mở khóa chương này sẽ do logic game xử lý dựa trên cờ trong player_saves.
    -- Ví dụ: Hoàn thành chương trước.
    UNIQUE(story_id, chapter_number) -- Mỗi chương trong một câu chuyện phải là duy nhất.
);

-- Các cảnh cụ thể trong một chương. Đây là đơn vị cơ bản của game.
CREATE TABLE scenes (
    id SERIAL PRIMARY KEY,
    chapter_id INTEGER NOT NULL REFERENCES chapters(id),
    scene_name TEXT NOT NULL,
    scene_type TEXT NOT NULL, -- 'dialogue', 'investigation', 'cutscene'
    background_image_path TEXT,
    background_music_path TEXT,
    order_index INTEGER DEFAULT 0 -- Thứ tự của cảnh trong chương.
);

-- =========== 2. MYSTERY & INVESTIGATION SYSTEM =================
-- Quản lý các vụ án chính trong mỗi chương.
CREATE TABLE cases (
    id SERIAL PRIMARY KEY,
    chapter_id INTEGER NOT NULL REFERENCES chapters(id),
    case_title TEXT NOT NULL,
    case_description TEXT
);

-- Bảng chứa tất cả bằng chứng có thể tìm thấy.
CREATE TABLE evidence (
    id SERIAL PRIMARY KEY,
    case_id INTEGER NOT NULL REFERENCES cases(id),
    evidence_name TEXT NOT NULL,
    description TEXT NOT NULL,
    image_path TEXT,
    is_key_evidence BOOLEAN DEFAULT FALSE -- Đánh dấu bằng chứng quan trọng để giải quyết vụ án.
);

-- Các điểm tương tác (hotspots) trong một cảnh điều tra.
CREATE TABLE investigation_points (
    id SERIAL PRIMARY KEY,
    scene_id INTEGER NOT NULL REFERENCES scenes(id),
    point_name TEXT NOT NULL,
    -- Vị trí và kích thước trên màn hình, ví dụ: '{"x": 100, "y": 200, "width": 50, "height": 50}'
    coordinates_json JSONB,
    
    -- Điều kiện để tương tác và kết quả
    requirements_json JSONB, -- ví dụ: '{"skill": "observation", "level": 2, "requires_item": "magnifying_glass"}'
    consequences_json JSONB, -- ví dụ: '{"gain_evidence_id": 15, "set_flag": "found_hidden_note"}'
    
    -- Cờ để đánh dấu điểm này đã được kiểm tra, lưu trong save file của người chơi.
    -- Ví dụ: "desk_drawer_searched"
    examined_flag_name TEXT NOT NULL UNIQUE
);

-- =========== 3. CHARACTER & DIALOGUE SYSTEM =================
-- Bảng quản lý tất cả nhân vật trong game.
CREATE TABLE characters (
    id SERIAL PRIMARY KEY,
    character_name TEXT NOT NULL UNIQUE,
    description TEXT,
    -- Thông tin liên quan đến vai trò trong vụ án, có thể là NULL nếu không phải nghi phạm
    alibi TEXT,
    motive TEXT,
    -- Đường dẫn đến file ảnh sprite của nhân vật
    default_sprite_path TEXT
);

-- Bảng chứa tất cả các dòng hội thoại hoặc tường thuật.
CREATE TABLE dialogue_entries (
    id SERIAL PRIMARY KEY,
    scene_id INTEGER NOT NULL REFERENCES scenes(id),
    -- Có thể NULL nếu là người dẫn chuyện (narrator)
    character_id INTEGER REFERENCES characters(id),
    
    dialogue_text TEXT NOT NULL,
    -- Biểu cảm của nhân vật khi nói câu này, ví dụ: "happy", "sad", "angry"
    character_expression TEXT,
    
    -- Điều kiện để dòng thoại này xuất hiện
    display_conditions_json JSONB, -- ví dụ: '{"requires_flag": "player_is_suspicious"}'
    -- Các thay đổi gây ra bởi dòng thoại này
    consequences_json JSONB, -- ví dụ: '{"change_sanity": -5, "set_flag": "character_is_nervous"}'
    
    order_index INTEGER NOT NULL -- Thứ tự của dòng thoại trong cảnh.
);

-- Bảng chứa các lựa chọn của người chơi.
CREATE TABLE scene_choices (
    id SERIAL PRIMARY KEY,
    -- Lựa chọn này xuất hiện sau dòng thoại nào.
    -- Có thể là NULL nếu lựa chọn xuất hiện ở đầu cảnh.
    after_dialogue_id INTEGER REFERENCES dialogue_entries(id),
    scene_id INTEGER NOT NULL REFERENCES scenes(id),

    choice_text TEXT NOT NULL,
    
    -- Điều kiện để lựa chọn này xuất hiện
    requirements_json JSONB, -- ví dụ: '{"skill": "persuasion", "level": 1, "has_evidence_id": 3}'
    
    -- ID của cảnh tiếp theo sẽ được tải khi người chơi chọn lựa chọn này.
    next_scene_id INTEGER NOT NULL REFERENCES scenes(id),

    -- Các thay đổi ngay lập tức khi chọn
    consequences_json JSONB, -- ví dụ: '{"set_flag": "suspect_agreed", "change_reputation": 5}'

    order_index INTEGER NOT NULL -- Thứ tự của lựa chọn trên màn hình.
);

-- =========== 4. SUPERNATURAL SYSTEM =================
-- Các sự kiện siêu nhiên được kịch bản sẵn.
CREATE TABLE supernatural_events (
    id SERIAL PRIMARY KEY,
    scene_id INTEGER NOT NULL REFERENCES scenes(id),
    event_name TEXT NOT NULL,
    description TEXT,
    
    -- Điều kiện để sự kiện được kích hoạt
    trigger_conditions_json JSONB, -- ví dụ: '{"skill": "psychic_sensitivity", "level": 2}'
    
    -- Hậu quả khi sự kiện xảy ra
    consequences_json JSONB, -- ví dụ: '{"change_sanity": -20, "gain_evidence_id": 15, "unlocks_dialogue": true}'
    
    -- Cờ để đảm bảo sự kiện chỉ xảy ra một lần
    triggered_flag_name TEXT NOT NULL UNIQUE
);

-- =========== 5. SAVE SYSTEM =================
-- Bảng quan trọng nhất, lưu trữ toàn bộ tiến trình của người chơi.
CREATE TABLE player_saves (
    id SERIAL PRIMARY KEY,
    save_slot INTEGER NOT NULL,
    player_name TEXT,
    save_description TEXT,
    
    -- Vị trí hiện tại của người chơi
    current_scene_id INTEGER NOT NULL REFERENCES scenes(id),
    
    -- Cột JSONB "thần kỳ" chứa tất cả trạng thái động của người chơi
    game_state JSONB NOT NULL,
    -- Cấu trúc ví dụ của game_state:
    -- {
    --   "sanity": 85,
    --   "reputation": 55,
    --   "skills": {
    --     "observation": 2,
    --     "psychic_sensitivity": 1,
    --     "persuasion": 1
    --   },
    --   "inventory_evidence_ids": [1, 3, 5],
    --   "story_flags": [
    --      "desk_drawer_searched", 
    --      "suspect_is_lying",
    --      "ghost_event_triggered"
    --   ]
    -- }
    
    playtime_seconds INTEGER DEFAULT 0,
    screenshot_path TEXT,
    last_played TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(save_slot)
);

-- =========== 6. INDEXES FOR PERFORMANCE =================
-- Tạo chỉ mục cho các khóa ngoại để tăng tốc độ truy vấn JOIN.
CREATE INDEX idx_chapters_story_id ON chapters(story_id);
CREATE INDEX idx_scenes_chapter_id ON scenes(chapter_id);
CREATE INDEX idx_cases_chapter_id ON cases(chapter_id);
CREATE INDEX idx_evidence_case_id ON evidence(case_id);
CREATE INDEX idx_investigation_points_scene_id ON investigation_points(scene_id);
CREATE INDEX idx_dialogue_entries_scene_id ON dialogue_entries(scene_id);
CREATE INDEX idx_scene_choices_scene_id ON scene_choices(scene_id);
CREATE INDEX idx_supernatural_events_scene_id ON supernatural_events(scene_id);

-- Tạo chỉ mục GIN trên cột JSONB để truy vấn vào các key bên trong hiệu quả.
-- Ví dụ này không bắt buộc cho game đơn giản, nhưng là một ví dụ về sức mạnh của Postgres.
CREATE INDEX idx_player_saves_game_state ON player_saves USING gin(game_state);
