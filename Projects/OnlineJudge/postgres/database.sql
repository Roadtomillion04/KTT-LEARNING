-- pasted from pgadmin, need to refactor after getting done with the issues

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

SELECT current_date as date, current_time as time;

CREATE TEMP TABLE shopping_cart (
  cart_id serial PRIMARY KEY,
  products text ARRAY
  );
  
INSERT INTO
  shopping_cart(products)
VALUES
  (ARRAY[['product_a\n output:', 'product_b'], ['product_c', 'product_d']]),
  (ARRAY['product_c', 'product_d']),
  (ARRAY['product_a', 'product_b', 'product_c']),
  (ARRAY['product_a', 'product_b', 'product_d']),
  (ARRAY['product_sab', 'product_d']);

SELECT
  *
FROM
  shopping_cart;

DROP TABLE INTERVIEW_QUESTIONS;

CREATE TABLE INTERVIEW_QUESTIONS (
	question_id SERIAL PRIMARY KEY,
	question text,
	problem_statement text,
	test_case_input text[],
	test_case_output text[]
)

INSERT INTO INTERVIEW_QUESTIONS (question, problem_statement, test_case_input, test_case_output)
VALUES ('Three sum', 'objectvie is to add 3 elements and check it matches target and return the indices', ARRAY[[1, 2, 3], [3, 4, 5]], ARRAY[6])
