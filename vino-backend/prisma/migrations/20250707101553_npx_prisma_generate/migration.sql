-- CreateTable
CREATE TABLE "cases" (
    "id" SERIAL NOT NULL,
    "chapter_id" INTEGER NOT NULL,
    "case_title" TEXT NOT NULL,
    "case_description" TEXT,

    CONSTRAINT "cases_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "chapters" (
    "id" SERIAL NOT NULL,
    "story_id" INTEGER NOT NULL,
    "chapter_number" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "chapters_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "characters" (
    "id" SERIAL NOT NULL,
    "character_name" TEXT NOT NULL,
    "description" TEXT,
    "alibi" TEXT,
    "motive" TEXT,
    "default_sprite_path" TEXT,

    CONSTRAINT "characters_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dialogue_entries" (
    "id" SERIAL NOT NULL,
    "scene_id" INTEGER NOT NULL,
    "character_id" INTEGER,
    "dialogue_text" TEXT NOT NULL,
    "character_expression" TEXT,
    "display_conditions_json" JSONB,
    "consequences_json" JSONB,
    "order_index" INTEGER NOT NULL,

    CONSTRAINT "dialogue_entries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evidence" (
    "id" SERIAL NOT NULL,
    "case_id" INTEGER NOT NULL,
    "evidence_name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "image_path" TEXT,
    "is_key_evidence" BOOLEAN DEFAULT false,

    CONSTRAINT "evidence_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "investigation_points" (
    "id" SERIAL NOT NULL,
    "scene_id" INTEGER NOT NULL,
    "point_name" TEXT NOT NULL,
    "coordinates_json" JSONB,
    "requirements_json" JSONB,
    "consequences_json" JSONB,
    "examined_flag_name" TEXT NOT NULL,

    CONSTRAINT "investigation_points_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "player_saves" (
    "id" SERIAL NOT NULL,
    "save_slot" INTEGER NOT NULL,
    "player_name" TEXT,
    "save_description" TEXT,
    "current_scene_id" INTEGER NOT NULL,
    "game_state" JSONB NOT NULL,
    "user_id" INTEGER,
    "playtime_seconds" INTEGER DEFAULT 0,
    "screenshot_path" TEXT,
    "last_played" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "player_saves_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "scene_choices" (
    "id" SERIAL NOT NULL,
    "after_dialogue_id" INTEGER,
    "scene_id" INTEGER NOT NULL,
    "choice_text" TEXT NOT NULL,
    "requirements_json" JSONB,
    "next_scene_id" INTEGER NOT NULL,
    "consequences_json" JSONB,
    "order_index" INTEGER NOT NULL,

    CONSTRAINT "scene_choices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "scenes" (
    "id" SERIAL NOT NULL,
    "chapter_id" INTEGER NOT NULL,
    "scene_name" TEXT NOT NULL,
    "scene_type" TEXT NOT NULL,
    "background_image_path" TEXT,
    "background_music_path" TEXT,
    "order_index" INTEGER DEFAULT 0,

    CONSTRAINT "scenes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stories" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "stories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "supernatural_events" (
    "id" SERIAL NOT NULL,
    "scene_id" INTEGER NOT NULL,
    "event_name" TEXT NOT NULL,
    "description" TEXT,
    "trigger_conditions_json" JSONB,
    "consequences_json" JSONB,
    "triggered_flag_name" TEXT NOT NULL,

    CONSTRAINT "supernatural_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user" (
    "id" SERIAL NOT NULL,
    "username" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "idx_cases_chapter_id" ON "cases"("chapter_id");

-- CreateIndex
CREATE INDEX "idx_chapters_story_id" ON "chapters"("story_id");

-- CreateIndex
CREATE UNIQUE INDEX "chapters_story_id_chapter_number_key" ON "chapters"("story_id", "chapter_number");

-- CreateIndex
CREATE UNIQUE INDEX "characters_character_name_key" ON "characters"("character_name");

-- CreateIndex
CREATE INDEX "idx_dialogue_entries_scene_id" ON "dialogue_entries"("scene_id");

-- CreateIndex
CREATE INDEX "idx_evidence_case_id" ON "evidence"("case_id");

-- CreateIndex
CREATE UNIQUE INDEX "investigation_points_examined_flag_name_key" ON "investigation_points"("examined_flag_name");

-- CreateIndex
CREATE INDEX "idx_investigation_points_scene_id" ON "investigation_points"("scene_id");

-- CreateIndex
CREATE UNIQUE INDEX "player_saves_save_slot_key" ON "player_saves"("save_slot");

-- CreateIndex
CREATE INDEX "idx_player_saves_game_state" ON "player_saves" USING GIN ("game_state");

-- CreateIndex
CREATE INDEX "idx_scene_choices_scene_id" ON "scene_choices"("scene_id");

-- CreateIndex
CREATE INDEX "idx_scenes_chapter_id" ON "scenes"("chapter_id");

-- CreateIndex
CREATE UNIQUE INDEX "stories_title_key" ON "stories"("title");

-- CreateIndex
CREATE UNIQUE INDEX "supernatural_events_triggered_flag_name_key" ON "supernatural_events"("triggered_flag_name");

-- CreateIndex
CREATE INDEX "idx_supernatural_events_scene_id" ON "supernatural_events"("scene_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_username_key" ON "user"("username");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- AddForeignKey
ALTER TABLE "cases" ADD CONSTRAINT "cases_chapter_id_fkey" FOREIGN KEY ("chapter_id") REFERENCES "chapters"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "chapters" ADD CONSTRAINT "chapters_story_id_fkey" FOREIGN KEY ("story_id") REFERENCES "stories"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "dialogue_entries" ADD CONSTRAINT "dialogue_entries_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "characters"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "dialogue_entries" ADD CONSTRAINT "dialogue_entries_scene_id_fkey" FOREIGN KEY ("scene_id") REFERENCES "scenes"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evidence" ADD CONSTRAINT "evidence_case_id_fkey" FOREIGN KEY ("case_id") REFERENCES "cases"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "investigation_points" ADD CONSTRAINT "investigation_points_scene_id_fkey" FOREIGN KEY ("scene_id") REFERENCES "scenes"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "player_saves" ADD CONSTRAINT "player_saves_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "player_saves" ADD CONSTRAINT "player_saves_current_scene_id_fkey" FOREIGN KEY ("current_scene_id") REFERENCES "scenes"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "scene_choices" ADD CONSTRAINT "scene_choices_after_dialogue_id_fkey" FOREIGN KEY ("after_dialogue_id") REFERENCES "dialogue_entries"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "scene_choices" ADD CONSTRAINT "scene_choices_next_scene_id_fkey" FOREIGN KEY ("next_scene_id") REFERENCES "scenes"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "scene_choices" ADD CONSTRAINT "scene_choices_scene_id_fkey" FOREIGN KEY ("scene_id") REFERENCES "scenes"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "scenes" ADD CONSTRAINT "scenes_chapter_id_fkey" FOREIGN KEY ("chapter_id") REFERENCES "chapters"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "supernatural_events" ADD CONSTRAINT "supernatural_events_scene_id_fkey" FOREIGN KEY ("scene_id") REFERENCES "scenes"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
