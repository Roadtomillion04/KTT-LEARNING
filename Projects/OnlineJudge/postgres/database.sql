CREATE TABLE USER_REGISTER (
	user_id SMALLSERIAL PRIMARY KEY, 
	first_name VARCHAR(30),
	last_name VARCHAR(30),
	email VARCHAR(30),
	department VARCHAR(50),
	roll_no VARCHAR(15),
	user_password VARCHAR(30),
	registration_time TIMESTAMP
)


CREATE TABLE INTERVIEW_QUESTIONS (
	question_id SERIAL PRIMARY KEY,
	question text,
	problem_statement text,
	test_cases jsonb,
	examples jsonb
)

CREATE TABLE ADMIN (
	admin_id SERIAL PRIMARY KEY,
	username text,
	email text,
	admin_password text
)


