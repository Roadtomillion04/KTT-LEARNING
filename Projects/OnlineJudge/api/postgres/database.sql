CREATE TABLE USER_REGISTER (
	user_id SERIAL PRIMARY KEY, 
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	email VARCHAR(60) NOT NULL,
	department VARCHAR(50) NOT NULL,
	roll_no VARCHAR(20) NOT NULL UNIQUE,
	user_password VARCHAR(30) NOT NULL,
	registration_time TIMESTAMP NOT NULL
)


CREATE TABLE INTERVIEW_QUESTIONS (
	question_id SERIAL PRIMARY KEY,
	question text NOT NULL,
	problem_statement text NOT NULL,
	test_cases jsonb NOT NULL,
	examples jsonb NOT NULL
)

CREATE TABLE ADMIN (
	admin_id SERIAL PRIMARY KEY,
	username text NOT NULL,
	email text NOT NULL,
	admin_password text NOT NULL
)

create table submissions (
	submission_id SERIAL PRIMARY KEY,
	test_id text NOT NULL,
	roll_no VARCHAR(20) UNIQUE,
	questions_passed jsonb,
	
	FOREIGN KEY (roll_no) references user_register (roll_no)
)

CREATE TABLE TEST_CONFIG (

	creation_id SERIAL PRIMARY KEY,
	test_id text NOT NULL,
	question_count INT NOT NULL,
	start_time time NOT NULL,
	end_time time NOT NULL,
	test_date date NOT NULL

)

