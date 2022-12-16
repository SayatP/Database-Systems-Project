create database charity;
use charity;


create table donor (
    ID int not null AUTO_INCREMENT,
    email varchar(256),
    first_name varchar(16) not null,
    last_name varchar(16) not null,
    password varchar(64) not null,
    address varchar(256),
    city varchar(128),
    country varchar(128),
    primary key (ID)
);

create table admin (
    ID int not null AUTO_INCREMENT,
    email varchar(256),
    first_name varchar(16) not null,
    last_name varchar(16) not null,
    password char(64) not null,
    primary key (ID)
);

create table client (
    ID int not null AUTO_INCREMENT,
    ssn char(11) not null,
    first_name varchar(16) not null,
    last_name varchar(16) not null,
    password char(64) not null,
    address varchar(256),
    city varchar(128),
    country varchar(128),
    email varchar(256) not null,
    unique (email),
    unique (ssn),
    primary key (ID)
);

create table service (
    ID int not null AUTO_INCREMENT,
    title varchar(64) not null,
    description varchar(2048) not null,
    budget decimal(15, 2) not null,
    -- we could use this, but I think MySQL doesn't support it
    -- create domain money_amount  decimal(10, 2) not null 
    -- constraint money_amount_positive
    -- check(money_amount > 0);
    created_at timestamp not null default CURRENT_TIMESTAMP,
    created_by int,
    foreign key (created_by) references admin(ID) on delete set null,
    primary key (ID)
);

create table application_form (
    ID int not null AUTO_INCREMENT,
    service_id int not null,
    name varchar(20) not null,
    text text not null,
    created_at timestamp not null default CURRENT_TIMESTAMP,
    foreign key (service_id) references service(ID) on delete cascade,
    unique (service_id, name),
    primary key (ID)
);

create table application (
    ID int not null AUTO_INCREMENT,
    text text not null,
    application_form_id int not null,
    client_id int not null,
    created_at timestamp not null default CURRENT_TIMESTAMP,
    foreign key (application_form_id) references application_form(ID) on delete cascade,
    foreign key (client_id) references client(ID) on delete cascade,
    primary key (ID)
);


create table attachment (
    ID int not null,
    name varchar(64) not null,
    url varchar(256) not null,
    -- we assume uploaded files are stored in a service similar to S3 as a good practice
    foreign key (ID) references application(ID) on delete cascade,
    primary key (ID, name)
    -- one application can have multiple application attachments, but each has different name
);

create table review (
    application_id int not null,
    reviewer_id int,
    reason varchar(2048) not null,
    status ENUM('approved', 'rejected', 'in progress'),
    created_at timestamp not null default CURRENT_TIMESTAMP,
    foreign key (application_id) references application(ID) on delete cascade,
    foreign key (reviewer_id) references admin(ID) on delete set null,
    primary key (application_id)
);

create table comment (
    application_id int not null,
    `index` int not null,
    author_email varchar(256) not null,
    created_at timestamp not null default CURRENT_TIMESTAMP,
    text text not null,
    foreign key (application_id) references application(ID) on delete cascade,
    primary key (application_id, `index`)
);

create table sponsorship (
    ID int not null AUTO_INCREMENT,
    donor_id int,
    service_id int,
    amount decimal(15, 2) not null,
    created_at timestamp not null default CURRENT_TIMESTAMP,
    foreign key (donor_id) references donor(ID) on delete set null,
    foreign key (service_id) references service(ID) on delete set null,
    check (amount > 0),
    primary key (ID)
);
