PRAGMA foreign_keys = ON;

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    fname VARCHAR(255),
    lname VARCHAR(255)
);

CREATE TABLE questions (
    question_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    body TEXT,
    author_id INT REFERENCES users(user_id)
);

CREATE TABLE question_follows (
    user_id INT REFERENCES users(user_id),
    question_id INT REFERENCES questions(question_id),
    PRIMARY KEY (user_id, question_id)
);

CREATE TABLE replies (
    reply_id SERIAL PRIMARY KEY,
    subject_question_id INT REFERENCES questions(question_id),
    parent_reply_id INT REFERENCES replies(reply_id),
    user_id INT REFERENCES users(user_id),
    body TEXT
);

CREATE TABLE question_likes (
    user_id INT REFERENCES users(user_id),
    question_id INT REFERENCES questions(question_id),
    PRIMARY KEY (user_id, question_id)
);