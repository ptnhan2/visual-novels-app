-- Bảng trạng thái tổng quát của player
CREATE TABLE player_status (
    id SERIAL PRIMARY KEY,
    save_id INTEGER REFERENCES player_saves(id),
    
    -- Trạng thái cơ bản
    detective_level INTEGER DEFAULT 1,
    total_experience INTEGER DEFAULT 0,
    skill_points_available INTEGER DEFAULT 0,
    
    -- Trạng thái tâm lý
    sanity_current INTEGER DEFAULT 100,
    sanity_max INTEGER DEFAULT 100,
    stress_level INTEGER DEFAULT 0,
    confidence_level INTEGER DEFAULT 50,
    
    -- Trạng thái vật lý
    health_current INTEGER DEFAULT 100,
    energy_current INTEGER DEFAULT 100,
    fatigue_level INTEGER DEFAULT 0,
    
    -- Xã hội
    reputation_police INTEGER DEFAULT 50,
    reputation_public INTEGER DEFAULT 50,
    reputation_occult INTEGER DEFAULT 0,
    
    -- Tài nguyên
    money INTEGER DEFAULT 1000,
    investigation_points INTEGER DEFAULT 10,
    
    -- Thống kê
    cases_solved INTEGER DEFAULT 0,
    mysteries_uncovered INTEGER DEFAULT 0,
    supernatural_encounters INTEGER DEFAULT 0,
    
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng kỹ năng cụ thể của từng player
CREATE TABLE player_skills (
    id SERIAL PRIMARY KEY,
    save_id INTEGER REFERENCES player_saves(id),
    skill_id INTEGER REFERENCES skill_definitions(id),
    
    -- Trạng thái kỹ năng
    current_level INTEGER DEFAULT 1,
    current_exp INTEGER DEFAULT 0,
    exp_to_next_level INTEGER DEFAULT 100,
    
    -- Thống kê sử dụng
    times_used INTEGER DEFAULT 0,
    success_count INTEGER DEFAULT 0,
    failure_count INTEGER DEFAULT 0,
    last_used TIMESTAMP,
    
    -- Unlock status
    is_unlocked BOOLEAN DEFAULT FALSE,
    unlock_date TIMESTAMP,
    
    -- Modifiers (từ items, perks, effects)
    temporary_bonus INTEGER DEFAULT 0,
    permanent_bonus INTEGER DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(save_id, skill_id)
);

