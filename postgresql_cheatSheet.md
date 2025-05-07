# PostgreSQL Cheat Sheet

## General PostgreSQL Commands

### 1. Login to PostgreSQL

```bash
psql -U postgres
```

### 2. Show Databases

```
\l
```

### 3. Create a New Database

```sql
CREATE DATABASE my_database;
```

### 4. Connect to a Database

```
\c my_database
```

### 5. List Tables

```
\dt
```

### 6. Describe a Table (Show Structure)

```
\d table_name
```

### 7. Show Columns in a Table

```sql
SELECT column_name FROM information_schema.columns WHERE table_name = 'table_name';
```

## User Management

### 1. Create a New User

```sql
CREATE USER my_user WITH PASSWORD 'password';
```

### 2. Grant Privileges to a User

```sql
GRANT ALL PRIVILEGES ON DATABASE my_database TO my_user;
```

### 3. Alter User Password

```sql
ALTER USER my_user WITH PASSWORD 'new_password';
```

### 4. List All Users

```
\du
```

### 5. Delete a User

```sql
DROP USER my_user;
```

## Table Management

### 1. Create a Table

```sql
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
```

### 2. Add a Column

```sql
ALTER TABLE students ADD COLUMN email VARCHAR(255);
```

### 3. Modify a Column

```sql
ALTER TABLE students ALTER COLUMN email SET NOT NULL;
```

### 4. Drop a Column

```sql
ALTER TABLE students DROP COLUMN email;
```

### 5. Delete a Table

```sql
DROP TABLE students;
```

## Data Manipulation

### 1. Insert Data into a Table

```sql
INSERT INTO students (name, email) VALUES ('Alice', 'alice@example.com');
```

### 2. Select Data from a Table

```sql
SELECT * FROM students;
```

### 3. Update Data in a Table

```sql
UPDATE students SET email = 'alice@newdomain.com' WHERE name = 'Alice';
```

### 4. Delete Data from a Table

```sql
DELETE FROM students WHERE name = 'Alice';
```

## Relationships & Foreign Keys

### 1. Create a notes Table with Foreign Key

```sql
CREATE TABLE notes (
    id SERIAL PRIMARY KEY,
    grade CHAR(1) NOT NULL,
    student_id INT,
    FOREIGN KEY (student_id) REFERENCES students(id)
);
```

### 2. Insert Data with Foreign Key

```sql
INSERT INTO notes (grade, student_id) VALUES ('A', 1);
```

### 3. Select All Notes for a Student

```sql
SELECT n.grade, s.name FROM notes n
JOIN students s ON n.student_id = s.id
WHERE s.id = 1;
```

### 4. List Notes for a Specific Student (Join)

```sql
SELECT students.name, notes.grade 
FROM students
JOIN notes ON students.id = notes.student_id
WHERE students.id = 1;
```

## Useful PostgreSQL Functions

### 1. Count Rows in a Table

```sql
SELECT COUNT(*) FROM students;
```

### 2. Get the Last Inserted ID (Last Inserted Record)

```sql
SELECT currval(pg_get_serial_sequence('students', 'id'));
```

### 3. Check for Existing Constraints

```sql
SELECT conname FROM pg_constraint WHERE conrelid = 'students'::regclass;
```

## Example: What We Made Today

### 1. Create students Table

```sql
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
```

### 2. Create notes Table with Foreign Key

```sql
CREATE TABLE notes (
    id SERIAL PRIMARY KEY,
    grade CHAR(1) NOT NULL,
    student_id INT,
    FOREIGN KEY (student_id) REFERENCES students(id)
);
```

### 3. Insert a Student

```sql
INSERT INTO students (name) VALUES ('Alice');
INSERT INTO students (name) VALUES ('Oscar');
```

### 4. Insert Notes for Students

```sql
INSERT INTO notes (grade, student_id) VALUES ('A', 1);  -- For Alice
INSERT INTO notes (grade, student_id) VALUES ('B', 2);  -- For Oscar
```

### 5. Retrieve All Notes for a Student

```sql
SELECT s.name, n.grade
FROM students s
JOIN notes n ON s.id = n.student_id
WHERE s.id = 1;  -- Alice's notes
```

### 6. Delete a Student (Cascades to Notes)

```sql
DELETE FROM students WHERE id = 1;
```

## Exiting PostgreSQL

```
\q
```
```
