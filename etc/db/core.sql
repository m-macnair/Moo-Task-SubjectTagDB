/* SubjectDB */
/* subject */
CREATE TABLE subject (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	string TEXT NOT NULL
);
CREATE INDEX subject_name ON subject(string);

CREATE TABLE tag (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	string TEXT NOT NULL
);
CREATE INDEX tag_name ON tag(string);


/* subject_tag*/
CREATE TABLE subject_tag (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	subject_id INTEGER,
	tag_id INTEGER
);
CREATE INDEX subject_tag_subject_id ON subject_tag(subject_id);
CREATE INDEX subject_tag_tag_id ON subject_tag(tag_id);



/* /SubjectDB */
