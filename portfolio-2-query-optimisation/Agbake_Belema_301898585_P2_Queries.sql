-- Show related result, course, student records (up to 20).
SELECT t0."result_id" AS "result_result_id",
       t0."assessment_code" AS "result_assessment_code",
       t2."course_id" AS "course_course_id",
       t2."course_code" AS "course_course_code",
       t1."student_id" AS "student_student_id",
       t1."cohort_year" AS "student_cohort_year"
FROM portfolio."result" t0
JOIN portfolio."student" t1 ON t0."student_id" = t1."student_id"
JOIN portfolio."course" t2 ON t0."course_id" = t2."course_id"
ORDER BY t0."result_id", t2."course_id", t1."student_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."result_id" AS "result_result_id",
       t0."assessment_code" AS "result_assessment_code",
       t2."course_id" AS "course_course_id",
       t2."course_code" AS "course_course_code",
       t1."student_id" AS "student_student_id",
       t1."cohort_year" AS "student_cohort_year"
FROM portfolio."result" t0
JOIN portfolio."student" t1 ON t0."student_id" = t1."student_id"
JOIN portfolio."course" t2 ON t0."course_id" = t2."course_id"
ORDER BY t0."result_id", t2."course_id", t1."student_id"
LIMIT 20;

-- Find result records where recorded_at matches "2026-03-10T09:30:00Z" (up to 20).
SELECT * FROM portfolio."result"
WHERE "recorded_at" IS NOT DISTINCT FROM '2026-03-10T09:30:00Z'
ORDER BY "result_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."result"
WHERE "recorded_at" IS NOT DISTINCT FROM '2026-03-10T09:30:00Z'
ORDER BY "result_id"
LIMIT 20;

-- Count result records for each student_id (up to 20 groups).
SELECT "student_id", count(*) AS record_count
FROM portfolio."result"
GROUP BY "student_id"
ORDER BY record_count DESC, "student_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "student_id", count(*) AS record_count
FROM portfolio."result"
GROUP BY "student_id"
ORDER BY record_count DESC, "student_id" NULLS LAST
LIMIT 20;
