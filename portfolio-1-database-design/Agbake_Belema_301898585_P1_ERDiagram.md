# University / Student Result Portal — ER diagram

```mermaid
erDiagram
    direction LR
    student {
        bigint student_id PK
        integer cohort_year
        text program_code
        boolean active
    }
    course {
        bigint course_id PK
        text course_code UK
        text title
        integer credits
    }
    result {
        bigint result_id PK
        bigint student_id FK
        bigint course_id FK
        text assessment_code
        numeric score
        timestamptz recorded_at
    }
    student ||--o{ result : "student_id"
    course ||--o{ result : "course_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Agbake_Belema_301898585_ERDiagram.png)
