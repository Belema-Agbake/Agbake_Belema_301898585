# University / Student Result Portal — SQL queries

## 1. Show related result, course, student records (up to 20).

```sql
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
```

| result_result_id | result_assessment_code | course_course_id | course_course_code | student_student_id | student_cohort_year |
| --- | --- | --- | --- | --- | --- |
| 3001 | QUIZ1 | 2001 | BIO101 | 1001 | 2024 |
| 3002 | EXAM1 | 2002 | MAT202 | 1002 | 2025 |

## 2. Find result records where recorded_at matches "2026-03-10T09:30:00Z" (up to 20).

```sql
SELECT * FROM portfolio."result"
WHERE "recorded_at" IS NOT DISTINCT FROM '2026-03-10T09:30:00Z'
ORDER BY "result_id"
LIMIT 20;
```

| result_id | student_id | course_id | assessment_code | score | recorded_at |
| --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | QUIZ1 | 87.5 | 2026-03-10T09:30:00+00:00 |

## 3. Count result records for each student_id (up to 20 groups).

```sql
SELECT "student_id", count(*) AS record_count
FROM portfolio."result"
GROUP BY "student_id"
ORDER BY record_count DESC, "student_id" NULLS LAST
LIMIT 20;
```

| student_id | record_count |
| --- | --- |
| 1001 | 1 |
| 1002 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.494 | 1.566, 1.494, 1.255 | Sort → Seq Scan | 139 |
| After index | 0.242 | 0.219, 0.291, 0.242 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 30 |

The median execution time changed from 1.494 ms to 0.242 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.528..1.529 rows=25 loops=1)
  Seq Scan on result (actual time=0.017..1.491 rows=25 loops=1)
Planning Time: 0.373 ms
Execution Time: 1.566 ms
```

### Before index, run 2

```text
Sort (actual time=1.465..1.467 rows=25 loops=1)
  Seq Scan on result (actual time=0.017..1.415 rows=25 loops=1)
Planning Time: 0.357 ms
Execution Time: 1.494 ms
```

### Before index, run 3

```text
Sort (actual time=1.226..1.228 rows=25 loops=1)
  Seq Scan on result (actual time=0.016..1.192 rows=25 loops=1)
Planning Time: 0.366 ms
Execution Time: 1.255 ms
```

### After index, run 1

```text
Sort (actual time=0.16..0.162 rows=25 loops=1)
  Bitmap Heap Scan on result (actual time=0.031..0.124 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=25 loops=1)
Planning Time: 0.575 ms
Execution Time: 0.219 ms
```

### After index, run 2

```text
Sort (actual time=0.212..0.214 rows=25 loops=1)
  Bitmap Heap Scan on result (actual time=0.04..0.152 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.02..0.021 rows=25 loops=1)
Planning Time: 0.774 ms
Execution Time: 0.291 ms
```

### After index, run 3

```text
Sort (actual time=0.183..0.185 rows=25 loops=1)
  Bitmap Heap Scan on result (actual time=0.032..0.125 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.017 rows=25 loops=1)
Planning Time: 0.548 ms
Execution Time: 0.242 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Agbake_Belema_301898585_P2_Queries.sql, then Agbake_Belema_301898585_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Agbake_Belema_301898585_P2_QueryResults.png) · [Index comparison](screenshots/Agbake_Belema_301898585_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

