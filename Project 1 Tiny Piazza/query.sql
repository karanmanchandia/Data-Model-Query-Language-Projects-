create table tiny_piazza.user
(
email varchar(100) not null,
display_name varchar(100) not null ,
password varchar(30) not null,
constraint userPK primary key (email)
);

create table tiny_piazza.teaching_user
(
email varchar(100),
display_name varchar(100),
constraint teaching_userPK primary key (email),
constraint teaching_userFK foreign key (email) references user (email)
);

create table tiny_piazza.student
(
email varchar(100),
display_name varchar(100),
constraint studentPK primary key (email),
constraint studentFK foreign key (email) references user (email)
);

create table tiny_piazza.course
(
university_name varchar(200) not null,
course_no varchar(10) not null,
year Year(4) not null,
semester varchar(6) not null check (semester in ('fall semester','spring semester','winter semester','summer semester')),
course_name varchar(100) not null,
creater_email varchar(100) not null unique,
constraint coursePK primary key (university_name, course_no, year, semester),
constraint courseFK foreign key (creater_email) references teaching_user (email)
);

create table tiny_piazza.update
(
updation_number int not null,
university_name varchar(200) not null,
course_no varchar(10) not null,
year Year(4) not null,
semester varchar(6) not null check (semester in ('fall semester','spring semester','winter semester','summer semester')),
updated_by_email varchar(100),
constraint updatePK primary key (updation_number, university_name, course_no, year, semester, updated_by_email),
constraint updateFK1 foreign key (updated_by_email) references teaching_user (email),
constraint updateFK2 foreign key (university_name, course_no, year, semester) references course (university_name, course_no, year, semester)
);

create table tiny_piazza.register
(
university_name varchar(200) not null,
course_no varchar(10) not null,
year Year(4) not null,
semester varchar(6) not null check (semester in ('fall semester','spring semester','winter semester','summer semester')),
registered_by_email varchar(100),
constraint registerPK primary key (university_name, course_no, year, semester, registered_by_email),
constraint registerFK1 foreign key (registered_by_email) references student (email),
constraint registerFK2 foreign key (university_name, course_no, year, semester) references course (university_name, course_no, year, semester)
);

create table tiny_piazza.post
(
university_name varchar(200) not null,
course_no varchar(10) not null,
year Year(4) not null,
semester varchar(6) not null check (semester in ('fall semester','spring semester','winter semester','summer semester')),
post_id int	not null unique,
posted_by_email varchar(100) not null,
creation_or_updation_id int not null,
constraint postPK primary key (university_name, course_no, year, semester, post_id, posted_by_email, creation_or_updation_id),
constraint postFK1 foreign key (university_name, course_no, year, semester) references course (university_name, course_no, year, semester),
constraint postFK2 foreign key (posted_by_email) references user (email)
);

create table tiny_piazza.question_post
(
question_post_id int not null,
title varchar(100) not null,
discription  varchar(500) not null,
time datetime not null,
constraint question_postPK primary key (question_post_id),
constraint question_postFK foreign key (question_post_id) references post (post_id)
);

create table tiny_piazza.answer_post
(
answer_post_id int not null,
answer varchar(500) not null,
time datetime not null,
constraint answer_postPK primary key (answer_post_id),
constraint answer_postFK foreign key (answer_post_id) references post (post_id)
);


