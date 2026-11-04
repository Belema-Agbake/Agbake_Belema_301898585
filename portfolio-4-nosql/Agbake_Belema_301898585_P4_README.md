# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection result_events for result_submitted and result_corrected events. These are fictional event examples based on result, student, course.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related course details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "result_submitted",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "result",
        "key": {
            "result_id": 3001
        },
        "snapshot": {
            "result_id": 3001,
            "student_id": 1001,
            "course_id": 2001,
            "assessment_code": "QUIZ1",
            "score": 87.5,
            "recorded_at": "2026-03-10T09:30:00Z"
        }
    },
    "embedded": {
        "course": [
            {
                "key": {
                    "course_id": 2001
                },
                "snapshot": {
                    "course_id": 2001,
                    "course_code": "BIO101",
                    "title": "Synthetic Biology",
                    "credits": 3
                },
                "via": [
                    "result.course_id → course"
                ]
            }
        ]
    },
    "references": {
        "student": [
            {
                "key": {
                    "student_id": 1001
                },
                "via": [
                    "result.student_id → student"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 2 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 4 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("result_events").find({"eventType":"result_submitted"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "result_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "result_id": 3001
    }
  },
  {
    "_id": "event_000003",
    "eventType": "result_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "result_id": 3002
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("result_events").find({"source.key.result_id":3001}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "result_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "result_id": 3001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "result_corrected",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "result_id": 3001
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("result_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "result_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "result_id": 3001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "result_corrected",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "result_id": 3001
    }
  },
  {
    "_id": "event_000003",
    "eventType": "result_submitted",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "result_id": 3002
    }
  },
  {
    "_id": "event_000004",
    "eventType": "result_corrected",
    "occurredAt": {
      "$date": "2030-01-01T10:03:00Z"
    },
    "source": {
      "result_id": 3002
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("result_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| result_corrected | 2 |
| result_submitted | 2 |

## Validation and suitability

MongoDB inserted 4 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 4 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Agbake_Belema_301898585_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Agbake_Belema_301898585_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

