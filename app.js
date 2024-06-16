const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");

const app = express();
const port = 3000;

app.use(cors());

// Create a connection to the database
const db = mysql.createConnection({
  host: "localhost",
  user: "root", // replace with your MySQL username
  password: "param1903", // replace with your MySQL password
  database: "ekalavya",
});

// Connect to the database
db.connect((err) => {
  if (err) {
    console.error("Error connecting to the database:", err);
    return;
  }
  console.log("Connected to the MySQL database.");
});

// Middleware to parse JSON bodies
app.use(express.json());

// Route to fetch mentors for a student
app.get("/student/:student_id/mentors", (req, res) => {
  const studentId = req.params.student_id;

  const query = `
        SELECT m.name AS mentor_name, mss.student_mentor_score
        FROM mentor m
        JOIN mentor_student_score mss ON m.mentor_id = mss.mentor_id
        WHERE mss.student_id = ?
        ORDER BY mss.student_mentor_score DESC
        LIMIT 1
    `;

  db.query(query, [studentId], (err, results) => {
    if (err) {
      console.error("Error fetching mentor names:", err);
      res.status(500).json({ error: "Failed to fetch mentor names" });
      return;
    }
    res.json(results);
  });
});

// Route to fetch mentees for a mentor in ranking order
// Route to fetch mentees for a mentor in ranking order with a score >= 0.5
app.get("/mentor/:mentor_id/mentees", (req, res) => {
  const mentorId = req.params.mentor_id;

  const query = `
      SELECT s.name AS student_name, mss.student_mentor_score
      FROM student s
      JOIN mentor_student_score mss ON s.student_id = mss.student_id
      WHERE mss.mentor_id = ? AND mss.student_mentor_score >= 0.5
      ORDER BY mss.student_mentor_score DESC
  `;

  db.query(query, [mentorId], (err, results) => {
    if (err) {
      console.error("Error fetching mentee names:", err);
      res.status(500).json({ error: "Failed to fetch mentee names" });
      return;
    }
    res.json(results);
  });
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
