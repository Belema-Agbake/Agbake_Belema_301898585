# University / Student Result Portal — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| student_id | result records (list) |
| --- | --- |
| 1001 | [3001] |
| 1002 | [3002] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| result.result_id | result.student_id | result.course_id | result.assessment_code | student.student_id | student.program_code | course.course_id | course.course_code |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | QUIZ1 | 1001 | SCI | 2001 | BIO101 |
| 3002 | 1002 | 2002 | EXAM1 | 1002 | ART | 2002 | MAT202 |

Key: result_id.

## 2NF: depend on the whole key

result: student_id is a proper part of candidate key (student_id, course_id, assessment_code), and determines student details. result: course_id is a proper part of candidate key (student_id, course_id, assessment_code), and determines course details.

## student_example

| student.student_id | student.program_code |
| --- | --- |
| 1001 | SCI |
| 1002 | ART |

## course_example

| course.course_id | course.course_code |
| --- | --- |
| 2001 | BIO101 |
| 2002 | MAT202 |

## result_example

| result.result_id | result.student_id | result.course_id | result.assessment_code |
| --- | --- | --- | --- |
| 3001 | 1001 | 2001 | QUIZ1 |
| 3002 | 1002 | 2002 | EXAM1 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## student

| student_id | cohort_year | program_code | active |
| --- | --- | --- | --- |
| 1001 | 2024 | SCI | true |
| 1002 | 2025 | ART | true |

## course

| course_id | course_code | title | credits |
| --- | --- | --- | --- |
| 2001 | BIO101 | Synthetic Biology | 3 |
| 2002 | MAT202 | Synthetic Mathematics | 4 |

## result

| result_id | student_id | course_id | assessment_code | score | recorded_at |
| --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | QUIZ1 | 87.5 | 2026-03-10T09:30:00+00:00 |
| 3002 | 1002 | 2002 | EXAM1 | 92 | 2026-04-15T14:00:00+00:00 |

## Dependencies

- student: (student_id) → cohort_year, program_code, active
- course: (course_id) → course_code, title, credits
- result: (result_id) → student_id, course_id, assessment_code, score, recorded_at

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
