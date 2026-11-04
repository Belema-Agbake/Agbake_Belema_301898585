-- University / Student Result Portal: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."student" (
  "student_id" bigint NOT NULL,
  "cohort_year" bigint NOT NULL,
  "program_code" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_student" PRIMARY KEY ("student_id")
);
CREATE TABLE portfolio."course" (
  "course_id" bigint NOT NULL,
  "course_code" text NOT NULL,
  "title" text NOT NULL,
  "credits" bigint NOT NULL,
  CONSTRAINT "pk_course" PRIMARY KEY ("course_id"),
  CONSTRAINT "uq_course_0" UNIQUE ("course_code")
);
CREATE TABLE portfolio."result" (
  "result_id" bigint NOT NULL,
  "student_id" bigint NOT NULL,
  "course_id" bigint NOT NULL,
  "assessment_code" text NOT NULL,
  "score" numeric(18,2) NOT NULL,
  "recorded_at" timestamptz NOT NULL,
  CONSTRAINT "pk_result" PRIMARY KEY ("result_id"),
  CONSTRAINT "uq_result_0" UNIQUE ("student_id", "course_id", "assessment_code")
);
ALTER TABLE portfolio."result" ADD CONSTRAINT "fk_result_0" FOREIGN KEY ("student_id") REFERENCES portfolio."student" ("student_id");
ALTER TABLE portfolio."result" ADD CONSTRAINT "fk_result_1" FOREIGN KEY ("course_id") REFERENCES portfolio."course" ("course_id");
ALTER TABLE portfolio."result" ADD CONSTRAINT "result_score_range" CHECK (("score" >= 0) AND ("score" <= 100));
COMMIT;
