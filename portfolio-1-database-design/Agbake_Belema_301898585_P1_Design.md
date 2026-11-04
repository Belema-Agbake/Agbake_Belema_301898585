# University / Student Result Portal — database design

My case study records student, course, result.

## Users

- Students
- Instructors
- Registrar staff

## Main operations

- Record an assessment result for a student and course
- Review results associated with a course
- Summarize assessment scores by course

## Entities

| Entity | Information stored |
| --- | --- |
| student | Stores synthetic student records without names. |
| course | Stores course identifiers and catalog attributes. |
| result | Stores one student's score for an assessment in a course. |

## student

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| student_id | BIGINT | PK | Yes |
| cohort_year | INTEGER |  | Yes |
| program_code | TEXT |  | Yes |
| active | BOOLEAN |  | Yes |


## course

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| course_id | BIGINT | PK | Yes |
| course_code | TEXT | Unique | Yes |
| title | TEXT |  | Yes |
| credits | INTEGER |  | Yes |
- Unique key: (course_code).

## result

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| result_id | BIGINT | PK | Yes |
| student_id | BIGINT | FK | Yes |
| course_id | BIGINT | FK | Yes |
| assessment_code | TEXT |  | Yes |
| score | NUMERIC(18,2) |  | Yes |
| recorded_at | TIMESTAMPTZ |  | Yes |
- student_id → student.student_id
- course_id → course.course_id
- Unique key: (student_id, course_id, assessment_code).

## Relationships and business rules

- Every result score must be between 0 and 100 inclusive.
- A student may have at most one result for a given assessment in a given course.
- Every result must reference an existing student.
- Every result must reference an existing course.

## Assumptions

- Student, course, and result primary keys are generated as globally unique identifiers; no actual student names or IDs are supplied.
- A result records one student's score for one assessment in one course; assessment_code distinguishes assessments within a course.
- Worked normalization example: Result keeps student_id and course_id as foreign keys, while student attributes belong in Student and course attributes belong in Course. Assessment code, score, and recording time remain in Result rather than repeating student or course attributes on each assessment row.

