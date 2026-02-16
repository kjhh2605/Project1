-- 0001_problem_generation_management.sql
-- 문제 생성/검증/관리 MVP 스키마

CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'problem_status') THEN
    CREATE TYPE problem_status AS ENUM ('draft', 'review', 'published', 'archived');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'problem_type') THEN
    CREATE TYPE problem_type AS ENUM ('bug_finding', 'performance');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'difficulty_level') THEN
    CREATE TYPE difficulty_level AS ENUM ('easy', 'medium', 'hard');
  END IF;
END
$$;

CREATE TABLE IF NOT EXISTS problem_sources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_type TEXT NOT NULL, -- github_pr | benchmark | manual
  repo TEXT,
  pr_number INT,
  pr_url TEXT,
  commit_sha TEXT,
  license TEXT,
  attribution TEXT,
  patch_hash TEXT,
  raw_payload JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS problems (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  problem_type problem_type NOT NULL,
  difficulty difficulty_level NOT NULL,
  category VARCHAR(30) NOT NULL,
  language VARCHAR(10) NOT NULL CHECK (language IN ('java', 'python')),
  buggy_code TEXT NOT NULL,
  answer_info JSONB NOT NULL,
  hints JSONB NOT NULL DEFAULT '[]'::jsonb,
  tags TEXT[] NOT NULL DEFAULT '{}',
  source_id UUID REFERENCES problem_sources(id),
  evaluation_rubric JSONB NOT NULL,
  status problem_status NOT NULL DEFAULT 'draft',
  submission_count INT NOT NULL DEFAULT 0,
  success_rate NUMERIC(5,2),
  avg_score NUMERIC(5,2),
  version INT NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  published_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS problem_test_cases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  problem_id UUID NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
  input TEXT NOT NULL,
  expected_output TEXT,
  time_limit_ms INT,
  memory_limit_mb INT,
  is_sample BOOLEAN NOT NULL DEFAULT FALSE,
  is_performance_test BOOLEAN NOT NULL DEFAULT FALSE,
  order_index INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS problem_reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  problem_id UUID NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
  reviewer_id UUID NOT NULL,
  is_compilable BOOLEAN NOT NULL DEFAULT FALSE,
  is_bug_reproducible BOOLEAN NOT NULL DEFAULT FALSE,
  is_fix_valid BOOLEAN NOT NULL DEFAULT FALSE,
  is_difficulty_correct BOOLEAN NOT NULL DEFAULT FALSE,
  is_category_correct BOOLEAN NOT NULL DEFAULT FALSE,
  is_description_clear BOOLEAN NOT NULL DEFAULT FALSE,
  comments TEXT,
  decision TEXT NOT NULL CHECK (decision IN ('approved', 'rejected', 'needs_revision')),
  reviewed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS generation_jobs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_filter JSONB NOT NULL,
  category VARCHAR(30),
  difficulty difficulty_level,
  max_count INT NOT NULL DEFAULT 10,
  status TEXT NOT NULL CHECK (status IN ('queued', 'running', 'completed', 'failed')),
  progress_total INT NOT NULL DEFAULT 0,
  progress_done INT NOT NULL DEFAULT 0,
  error_message TEXT,
  requested_by UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_problems_category ON problems(category);
CREATE INDEX IF NOT EXISTS idx_problems_difficulty ON problems(difficulty);
CREATE INDEX IF NOT EXISTS idx_problems_language ON problems(language);
CREATE INDEX IF NOT EXISTS idx_problems_status ON problems(status);
CREATE INDEX IF NOT EXISTS idx_problems_tags_gin ON problems USING GIN(tags);
CREATE INDEX IF NOT EXISTS idx_problem_sources_repo_pr ON problem_sources(repo, pr_number);
CREATE INDEX IF NOT EXISTS idx_problem_reviews_problem_id ON problem_reviews(problem_id);
CREATE INDEX IF NOT EXISTS idx_generation_jobs_status ON generation_jobs(status);
