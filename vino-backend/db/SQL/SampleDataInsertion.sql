-- ##################################################################
-- #  SAMPLE DATA FOR SUPERNATURAL MYSTERY VISUAL NOVEL             #
-- ##################################################################

-- Start a transaction to ensure all inserts succeed or none do.
BEGIN;

-- =========== 1. CORE STRUCTURE DATA =================
-- Create the main story
INSERT INTO stories (id, title, description) VALUES
(1, 'The Phantom of the Old Theater', 'A detective with supernatural abilities investigates strange cases at the old Amethyst Theater, where dark secrets hide behind the velvet curtain.');

-- Create Chapter 1
INSERT INTO chapters (id, story_id, chapter_number, title, description) VALUES
(1, 1, 1, 'Chapter 1: The Opening Act', 'The first case begins with the mysterious disappearance of the lead actress, Eliza Reed, right before opening night.');

-- Create scenes for Chapter 1
INSERT INTO scenes (id, chapter_id, scene_name, scene_type, background_image_path, background_music_path, order_index) VALUES
(1, 1, 'Detective''s Office', 'dialogue', 'backgrounds/office_day.jpg', 'music/office_theme.mp3', 1),
(2, 1, 'Outside the Amethyst Theater', 'dialogue', 'backgrounds/theater_exterior.jpg', 'music/suspense_intro.mp3', 2),
(3, 1, 'Main Stage - Crime Scene', 'investigation', 'backgrounds/stage_crime_scene.jpg', 'music/investigation_theme.mp3', 3),
(4, 1, 'Eliza''s Dressing Room', 'investigation', 'backgrounds/dressing_room.jpg', 'music/investigation_theme.mp3', 4),
(5, 1, 'Interviewing the Director', 'dialogue', 'backgrounds/backstage.jpg', 'music/suspense_intro.mp3', 5),
(6, 1, 'Chapter 1 End Scene', 'cutscene', 'backgrounds/office_night.jpg', 'music/chapter_end.mp3', 6);

-- =========== 2. MYSTERY & INVESTIGATION DATA =================
-- Create the case for Chapter 1
INSERT INTO cases (id, chapter_id, case_title, case_description) VALUES
(1, 1, 'The Vanishing of Eliza Reed', 'Lead actress Eliza Reed has vanished without a trace from her dressing room, leaving behind a suspicious scene.');

-- Create evidence related to the case
INSERT INTO evidence (id, case_id, evidence_name, description, image_path, is_key_evidence) VALUES
(1, 1, 'Torn Letter', 'A threatening letter, torn in half, found in a trash can.', 'items/torn_letter.png', TRUE),
(2, 1, 'Strange White Powder', 'A fine white powder found near the window, doesn''t look like makeup.', 'items/white_powder.png', FALSE),
(3, 1, 'Eliza''s Diary', 'A diary revealing that Eliza was afraid of a "phantom" in the theater.', 'items/diary.png', TRUE),
(4, 1, 'Insurance Policy', 'A large life insurance policy with the director, Victor, as the beneficiary.', 'items/insurance_policy.png', TRUE);

-- Create investigation points in the investigation scenes
INSERT INTO investigation_points (id, scene_id, point_name, coordinates_json, requirements_json, consequences_json, examined_flag_name) VALUES
(1, 3, 'Stage Trash Can', '{"x": 750, "y": 450, "width": 80, "height": 100}', NULL, '{"gain_evidence_id": 1}', 'trash_can_searched'),
(2, 4, 'Makeup Table', '{"x": 200, "y": 300, "width": 250, "height": 150}', '{"skill": "observation", "level": 1}', '{"gain_evidence_id": 3}', 'makeup_table_searched'),
(3, 4, 'Dressing Room Window', '{"x": 800, "y": 150, "width": 150, "height": 250}', '{"skill": "observation", "level": 2}', '{"gain_evidence_id": 2, "set_flag": "window_was_forced"}', 'dressing_room_window_checked');

-- =========== 3. CHARACTER & DIALOGUE DATA =================
-- Create the characters
INSERT INTO characters (id, character_name, description, alibi, motive, default_sprite_path) VALUES
(1, 'Detective Kaito', 'The protagonist, a detective with supernatural senses.', NULL, NULL, 'sprites/kaito_neutral.png'),
(2, 'Victor Sterling', 'The demanding and ambitious director of the play.', 'Claims he was in his office all evening.', 'A failed play would bankrupt him.', 'sprites/victor_neutral.png'),
(3, 'Leo the Stagehand', 'The quiet stagehand who knows every corner of the theater.', 'Was in the rafters checking the lights.', 'Had a public argument with Eliza.', 'sprites/leo_neutral.png'),
(4, 'Eliza Reed', 'The victim, a talented but mysterious actress.', NULL, NULL, 'sprites/eliza_photo.png');

-- Create dialogue entries
-- Scene 1: Office
INSERT INTO dialogue_entries (id, scene_id, character_id, dialogue_text, character_expression, order_index) VALUES
(1, 1, 1, '(The phone rings... Another case, I presume?)', 'thought', 1),
(2, 1, NULL, '"Detective Kaito? This is Victor Sterling, director of the Amethyst Theater. My lead actress... she''s gone! Please, you have to come at once!"', NULL, 2);

-- Scene 5: Interviewing Victor
INSERT INTO dialogue_entries (id, scene_id, character_id, dialogue_text, character_expression, consequences_json, order_index) VALUES
(3, 5, 1, 'Mr. Sterling, can you tell me the last time you saw Ms. Reed?', 'neutral', NULL, 1),
(4, 5, 2, 'About an hour before the show. She seemed very nervous. Stage fright, I imagine.', 'nervous', '{"set_flag": "victor_seems_nervous"}', 2),
(5, 5, 1, '(He seems to be hiding something...)', 'thought', NULL, 3);

-- Create a choice for the player
INSERT INTO scene_choices (id, after_dialogue_id, scene_id, choice_text, requirements_json, next_scene_id, consequences_json, order_index) VALUES
(1, 4, 5, '[PERSUADE] "Stage fright, or was it something else, sir?"', '{"skill": "persuasion", "level": 1}', 5, '{"set_flag": "pressed_victor_further"}', 1),
(2, 4, 5, '[PRESENT EVIDENCE] "I found this letter. Do you know anything about it?"', '{"has_evidence_id": 1}', 5, '{"set_flag": "showed_victor_the_letter"}', 2),
(3, 4, 5, 'End the interview.', NULL, 4, NULL, 3); -- Go back to the dressing room

-- =========== 4. SUPERNATURAL SYSTEM DATA =================
-- Create a supernatural event
INSERT INTO supernatural_events (id, scene_id, event_name, description, trigger_conditions_json, consequences_json, triggered_flag_name) VALUES
(1, 4, 'A Chilling Whisper', 'A cold whisper saying "Help me..." echoes from a dark corner of the room.', '{"skill": "psychic_sensitivity", "level": 1}', '{"change_sanity": -10, "set_flag": "heard_ghostly_whisper"}', 'dressing_room_whisper_triggered');

-- =========== 5. SAVE SYSTEM DATA =================
-- Create a sample save file for a new player
INSERT INTO player_saves (id, save_slot, player_name, save_description, current_scene_id, game_state, playtime_seconds) VALUES
(1, 1, 'Kaito', 'Starting a new case', 1, 
'{
  "sanity": 100,
  "reputation": 50,
  "skills": {
    "observation": 1,
    "psychic_sensitivity": 1,
    "persuasion": 1
  },
  "inventory_evidence_ids": [],
  "story_flags": []
}', 0);

-- Commit the transaction to finalize the changes.
COMMIT;

-- ##################################################################
-- #  END OF SAMPLE DATA                                            #
-- ##################################################################