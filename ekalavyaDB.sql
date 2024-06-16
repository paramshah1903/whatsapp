use ekalavya;

CREATE TABLE student (
    student_id INT NOT NULL AUTO_INCREMENT, -- For MySQL; use SERIAL for PostgreSQL
    email VARCHAR(255) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    name VARCHAR(255) NOT NULL,
    language VARCHAR(100) NOT NULL,
    aspiring_test VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL,
    domain VARCHAR(100) NOT NULL,
    PRIMARY KEY (student_id)
);

INSERT INTO student (email, contact_number, name, language, aspiring_test, region, domain)
VALUES
('priya.patel@example.com', '9876543210', 'Priya Patel', 'Gujarati', 'CLAT', 'Gujarat', 'Law'),
('rohan.sharma@example.com', '9876543211', 'Rohan Sharma', 'Hindi', 'BCA', 'Rajasthan', 'Technology'),
('nisha.kulkarni@example.com', '9876543212', 'Nisha Kulkarni', 'Marathi', 'CUET', 'Maharashtra', 'Art'),
('ajay.mehta@example.com', '9876543213', 'Ajay Mehta', 'English', 'CLAT', 'Gujarat', 'Law'),
('meena.chopra@example.com', '9876543214', 'Meena Chopra', 'Hindi', 'BCA', 'Rajasthan', 'Technology'),
('sunita.gowda@example.com', '9876543215', 'Sunita Gowda', 'English', 'CUET', 'Maharashtra', 'Art'),
('vivek.purohit@example.com', '9876543216', 'Vivek Purohit', 'Marathi', 'CLAT', 'Maharashtra', 'Law'),
('karan.singh@example.com', '9876543217', 'Karan Singh', 'English', 'BCA', 'Rajasthan', 'Technology'),
('anita.raj@example.com', '9876543218', 'Anita Raj', 'Hindi', 'CUET', 'Gujarat', 'Art'),
('deepak.joshi@example.com', '9876543219', 'Deepak Joshi', 'Marathi', 'CLAT', 'Maharashtra', 'Law'),
('ayush.joshi@example.com', '9869657364', 'Ayush Jain', 'Marathi', 'CLAT', 'Maharashtra', 'Law');

INSERT INTO student (email, contact_number, name, language, aspiring_test, region, domain)
VALUES ('ayush.joshi@example.com', '9869657364', 'Ayush Jain', 'Marathi', 'CLAT', 'Maharashtra', 'Law');


select * from student;

CREATE TABLE mentor (
    mentor_id INT NOT NULL AUTO_INCREMENT,  -- For MySQL; use SERIAL for PostgreSQL
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    contact VARCHAR(20) NOT NULL,
    language VARCHAR(100) NOT NULL,
    test_guidance VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL,
    domain VARCHAR(100) NOT NULL,
    PRIMARY KEY (mentor_id)
);

INSERT INTO mentor (name, email, contact, language, test_guidance, region, domain)
VALUES
('Sudha Singh', 'sudha.singh@example.com', '9123456780', 'Hindi', 'CLAT', 'Rajasthan', 'Law'),
('Rajesh Kumar', 'rajesh.kumar@example.com', '9123456781', 'English', 'BCA', 'Gujarat', 'Technology'),
('Geeta Reddy', 'geeta.reddy@example.com', '9123456782', 'Marathi', 'CUET', 'Maharashtra', 'Art'),
('Amit Patel', 'amit.patel@example.com', '9123456783', 'Gujarati', 'CLAT', 'Gujarat', 'Law'),
('Nandita Bose', 'nandita.bose@example.com', '9123456784', 'English', 'CUET', 'Rajasthan', 'Art');

select * from mentor;

CREATE TABLE mentor_student_score (
    mentor_id INT,
    student_id INT,
    student_mentor_score DECIMAL(3,2),
    PRIMARY KEY (mentor_id, student_id),
    FOREIGN KEY (mentor_id) REFERENCES mentor(mentor_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

INSERT INTO mentor_student_score (mentor_id, student_id, student_mentor_score)
SELECT 
    m.mentor_id,
    s.student_id,
    (CASE WHEN s.domain = m.domain THEN 0.5 ELSE 0 END
     + CASE WHEN s.aspiring_test = m.test_guidance THEN 0.25 ELSE 0 END
     + CASE WHEN s.language = m.language THEN 0.15 ELSE 0 END
     + CASE WHEN s.region = m.region THEN 0.1 ELSE 0 END) AS score
FROM 
    student s
CROSS JOIN 
    mentor m;
    
select * from mentor_student_score;

CREATE TABLE best_student_mentor_match (
    student_name VARCHAR(255),
    mentor_name VARCHAR(255),
    student_mentor_score DECIMAL(3,2),
    PRIMARY KEY (student_name, mentor_name)
);

INSERT INTO best_student_mentor_match (student_name, mentor_name, student_mentor_score)
SELECT 
    s.name AS student_name,
    m.name AS mentor_name,
    mss.student_mentor_score
FROM 
    student s
JOIN 
    mentor_student_score mss ON s.student_id = mss.student_id
JOIN 
    mentor m ON m.mentor_id = mss.mentor_id
JOIN 
    (
        SELECT 
            student_id, 
            MAX(student_mentor_score) AS max_score
        FROM 
            mentor_student_score
        GROUP BY 
            student_id
    ) max_scores ON mss.student_id = max_scores.student_id AND mss.student_mentor_score = max_scores.max_score;

select * from best_student_mentor_match;

CREATE TABLE performance (
    performance_id INT NOT NULL AUTO_INCREMENT, -- For MySQL; use SERIAL for PostgreSQL
    student_id INT NOT NULL,
    attendance DECIMAL(5,2) NOT NULL, -- Percentage out of 100
    recent_test_score DECIMAL(5,2) NOT NULL, -- Score out of 100
    courses_completed INT NOT NULL CHECK (courses_completed <= 6), -- Courses completed out of 6
    PRIMARY KEY (performance_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);


INSERT INTO performance (student_id, attendance, recent_test_score, courses_completed)
VALUES
(1, 95.50, 85.00, 3),
(2, 60.00, 70.00, 1),
(3, 75.00, 55.00, 2),
(4, 100.00, 95.00, 4),
(5, 50.00, 40.00, 1),
(6, 92.00, 65.00, 2),
(7, 89.50, 78.00, 4),
(8, 85.00, 88.00, 3),
(9, 70.00, 60.00, 2),
(10, 95.00, 72.00, 2);


select * from performance;

INSERT INTO performance (student_id, attendance, recent_test_score, courses_completed)
VALUES (11, 45.00, 37.00, 4);



