-- Bảng supernatural events (events xảy ra trong game)
CREATE TABLE supernatural_events (
    id INTEGER PRIMARY KEY,
    case_id INTEGER REFERENCES cases(id),
    event_name TEXT NOT NULL,
    event_type TEXT, -- 'ghost_sighting', 'psychic_vision', 'poltergeist', 'possession'
    description TEXT,
    
    -- Trigger conditions
    trigger_location_id INTEGER REFERENCES locations(id),
    trigger_conditions TEXT, -- JSON: conditions for this event to occur
    
    -- Effects on player
    sanity_impact INTEGER DEFAULT 0,
    reveals_information TEXT,
    unlocks_evidence_id INTEGER REFERENCES evidence(id),
    
    -- Event behavior
    is_recurring BOOLEAN DEFAULT FALSE,
    intensity_level INTEGER DEFAULT 1,
    
    -- Detection requirements (tích hợp với skill system)
    detection_skill_checks TEXT, -- JSON: {"observation": 30, "psychic_sensitivity": 10}
    investigation_skill_checks TEXT, -- JSON: {"investigation": 40, "occult_knowledge": 20}
    
    -- Player interaction
    can_be_investigated BOOLEAN DEFAULT TRUE,
    min_psychic_sensitivity INTEGER DEFAULT 0,
    min_spiritual_awareness INTEGER DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);