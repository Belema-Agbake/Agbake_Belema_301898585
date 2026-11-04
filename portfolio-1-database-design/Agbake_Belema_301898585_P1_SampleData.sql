-- Fictional sample records for University / Student Result Portal.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."student" ("student_id", "cohort_year", "program_code", "active") VALUES (1001, 2024, 'SCI', TRUE);
INSERT INTO portfolio."student" ("student_id", "cohort_year", "program_code", "active") VALUES (1002, 2025, 'ART', TRUE);
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "credits") VALUES (2001, 'BIO101', 'Synthetic Biology', 3);
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "credits") VALUES (2002, 'MAT202', 'Synthetic Mathematics', 4);
INSERT INTO portfolio."result" ("result_id", "student_id", "course_id", "assessment_code", "score", "recorded_at") VALUES (3001, 1001, 2001, 'QUIZ1', 87.5, '2026-03-10T09:30:00Z');
INSERT INTO portfolio."result" ("result_id", "student_id", "course_id", "assessment_code", "score", "recorded_at") VALUES (3002, 1002, 2002, 'EXAM1', 92, '2026-04-15T14:00:00+00:00');
COMMIT;
