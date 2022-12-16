-- first let's see whats already there
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    INDEX_NAME,
    INDEX_TYPE
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'charity';
-- +------------------+---------------------+---------------------+------------+
-- | TABLE_NAME       | COLUMN_NAME         | INDEX_NAME          | INDEX_TYPE |
-- +------------------+---------------------+---------------------+------------+
-- | donor            | ID                  | PRIMARY             | BTREE      |
-- | admin            | ID                  | PRIMARY             | BTREE      |
-- | client           | ID                  | PRIMARY             | BTREE      |
-- | client           | email               | email               | BTREE      |
-- | client           | ssn                 | ssn                 | BTREE      |
-- | service          | ID                  | PRIMARY             | BTREE      |
-- | service          | created_by          | created_by          | BTREE      |
-- | application_form | ID                  | PRIMARY             | BTREE      |
-- | application_form | service_id          | service_id          | BTREE      |
-- | application_form | name                | service_id          | BTREE      |
-- | application      | ID                  | PRIMARY             | BTREE      |
-- | application      | application_form_id | application_form_id | BTREE      |
-- | application      | client_id           | client_id           | BTREE      |
-- | attachment       | ID                  | PRIMARY             | BTREE      |
-- | attachment       | name                | PRIMARY             | BTREE      |
-- | review           | application_id      | PRIMARY             | BTREE      |
-- | review           | reviewer_id         | reviewer_id         | BTREE      |
-- | comment          | ID                  | PRIMARY             | BTREE      |
-- | comment          | index               | PRIMARY             | BTREE      |
-- | sponsorship      | ID                  | PRIMARY             | BTREE      |
-- | sponsorship      | donor_id            | donor_id            | BTREE      |
-- | sponsorship      | service_id          | service_id          | BTREE      |
-- | service2         | ID                  | PRIMARY             | BTREE      |
-- | service2         | created_by          | created_by          | BTREE      |
-- +------------------+---------------------+---------------------+------------+
create index sponsorship_created_at on sponsorship(created_at);
create index comment_created_at on comment(created_at);
create index review_status  on review(status);
drop index ssn on client;
create index client_ssn using hash on client(ssn);
create index sponsorship_amount on sponsorship(amount);