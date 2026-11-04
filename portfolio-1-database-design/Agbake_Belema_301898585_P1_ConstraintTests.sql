-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. student pk violation. Expected: pk_student, SQLSTATE 23505.
INSERT INTO portfolio."student" ("student_id", "cohort_year", "program_code", "active")
VALUES (1001, 2026, 'ENG', FALSE);

-- 2. student id not null. Expected: student_id, SQLSTATE 23502.
INSERT INTO portfolio."student" ("student_id", "cohort_year", "program_code", "active")
VALUES (NULL, 2026, 'ENG', TRUE);

-- 3. student cohort not null. Expected: cohort_year, SQLSTATE 23502.
INSERT INTO portfolio."student" ("student_id", "cohort_year", "program_code", "active")
VALUES (4101, NULL, 'ENG', TRUE);

-- 4. student program not null. Expected: program_code, SQLSTATE 23502.
INSERT INTO portfolio."student" ("student_id", "cohort_year", "program_code", "active")
VALUES (4102, 2026, NULL, TRUE);

-- 5. student active not null. Expected: active, SQLSTATE 23502.
INSERT INTO portfolio."student" ("student_id", "cohort_year", "program_code", "active")
VALUES (4103, 2026, 'ENG', NULL);

-- 6. course pk violation. Expected: pk_course, SQLSTATE 23505.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "credits")
VALUES (2001, 'CHEM303', 'Synthetic Chemistry', 3);

-- 7. course unique violation. Expected: uq_course_0, SQLSTATE 23505.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "credits")
VALUES (4201, 'BIO101', 'Alternate Synthetic Biology', 2);

-- 8. course id not null. Expected: course_id, SQLSTATE 23502.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "credits")
VALUES (NULL, 'CHEM303', 'Synthetic Chemistry', 3);

-- 9. course code not null. Expected: course_code, SQLSTATE 23502.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "credits")
VALUES (4202, NULL, 'Synthetic Chemistry', 3);

-- 10. course title not null. Expected: title, SQLSTATE 23502.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "credits")
VALUES (4203, 'CHEM303', NULL, 3);

-- 11. course credits not null. Expected: credits, SQLSTATE 23502.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "credits")
VALUES (4204, 'CHEM303', 'Synthetic Chemistry', NULL);

-- 12. result pk violation. Expected: pk_result, SQLSTATE 23505.
INSERT INTO portfolio."result" ("result_id", "student_id", "course_id", "assessment_code", "score", "recorded_at")
VALUES (3001, 1002, 2002, 'MAKEUP1', 75, '2026-05-01T10:00:00Z');

-- 13. result unique violation. Expected: uq_result_0, SQLSTATE 23505.
INSERT INTO portfolio."result" ("result_id", "student_id", "course_id", "assessment_code", "score", "recorded_at")
VALUES (4301, 1001, 2001, 'QUIZ1', 80, '2026-05-02T10:00:00Z');

-- 14. result student fk violation. Expected: fk_result_0, SQLSTATE 23503.
INSERT INTO portfolio."result" ("result_id", "student_id", "course_id", "assessment_code", "score", "recorded_at")
VALUES (4302, 9991, 2001, 'NEW1', 80, '2026-05-03T10:00:00Z');

-- 15. result course fk violation. Expected: fk_result_1, SQLSTATE 23503.
INSERT INTO portfolio."result" ("result_id", "student_id", "course_id", "assessment_code", "score", "recorded_at")
VALUES (4303, 1001, 9992, 'NEW1', 80, '2026-05-04T10:00:00Z');

-- 16. result id not null. Expected: result_id, SQLSTATE 23502.
INSERT INTO portfolio."result" ("result_id", "student_id", "course_id", "assessment_code", "score", "recorded_at")
VALUES (NULL, 1002, 2002, 'NEW2', 80, '2026-05-05T10:00:00Z');

-- 17. result student not null. Expected: student_id, SQLSTATE 23502.
INSERT INTO portfolio."result" ("result_id", "student_id", "course_id", "assessment_code", "score", "recorded_at")
VALUES (4304, NULL, 2002, 'NEW2', 80, '2026-05-06T10:00:00Z');

-- 18. result course not null. Expected: course_id, SQLSTATE 23502.
INSERT INTO portfolio."result" ("result_id", "student_id", "course_id", "assessment_code", "score", "recorded_at")
VALUES (4305, 1002, NULL, 'NEW2', 80, '2026-05-07T10:00:00Z');

-- 19. result assessment not null. Expected: assessment_code, SQLSTATE 23502.
INSERT INTO portfolio."result" ("result_id", "student_id", "course_id", "assessment_code", "score", "recorded_at")
VALUES (4306, 1002, 2002, NULL, 80, '2026-05-08T10:00:00Z');

-- 20. result score not null. Expected: score, SQLSTATE 23502.
INSERT INTO portfolio."result" ("result_id", "student_id", "course_id", "assessment_code", "score", "recorded_at")
VALUES (4307, 1002, 2002, 'NEW3', NULL, '2026-05-09T10:00:00Z');

-- 21. result recorded not null. Expected: recorded_at, SQLSTATE 23502.
INSERT INTO portfolio."result" ("result_id", "student_id", "course_id", "assessment_code", "score", "recorded_at")
VALUES (4308, 1002, 2002, 'NEW4', 80, NULL);

-- 22. result score check violation. Expected: result_score_range, SQLSTATE 23514.
INSERT INTO portfolio."result" ("result_id", "student_id", "course_id", "assessment_code", "score", "recorded_at")
VALUES (4309, 1002, 2002, 'NEW5', 101, '2026-05-10T10:00:00Z');
