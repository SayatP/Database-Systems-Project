-- first lets generate a some country data for client and donors for aggregated queries
update client set country = null;
update client set country = 'Usa' where rand() < 0.3;
update client set country = 'France' where country is null and rand() < 0.6;
update client set country = 'China' where country is null;

update donor set country = null;
update donor set country = 'Usa' where rand() < 0.3;
update donor set country = 'France' where country is null and rand() < 0.6;
update donor set country = 'China' where country is null;

-- two countries with most clients
select country, count(*) from client group by country order by count(*) desc limit 2;

-- contribution total and count per donor
select
    concat(first_name, ' ', last_name) as full_name,
    sum(amount) as total,
    count(*) as number_of_donations
from
    donor
    left join sponsorship on donor.ID = sponsorship.donor_id
group by
    donor_id,
    first_name,
    last_name;

-- contribution total and count per country
select
    country,
    sum(amount) as total,
    count(*) as number_of_donations
from
    donor
    join sponsorship on donor.ID = sponsorship.donor_id
group by
    country;

-- application count aggregated per client
with client_review as (
    select
        client_id,
        concat(first_name, ' ', last_name) as name,
        status
    from
        client
        join application on client.ID = application.client_id
        join review on application.ID = review.application_id
)
select
    name,
    count(*)
from
    client_review
group by
    name;


-- application review status aggregated per client
-- I know there are shorter ways)
with client_review_rejected as (
    select
        client_id,
        concat(first_name, ' ', last_name) as name,
        count(*) as rejected_count
    from
        client
        left join application on client.ID = application.client_id
        left join review on application.ID = review.application_id
    where
        status = 'rejected'
    group by
        client_id
),
client_review_in_progress as (
    select
        client_id,
        concat(first_name, ' ', last_name) as name,
        count(*) as in_progress_count
    from
        client
        left join application on client.ID = application.client_id
        left join review on application.ID = review.application_id
    where
        status = 'in progress'
    group by
        client_id
),
client_review_approved as (
    select
        client_id,
        concat(first_name, ' ', last_name) as name,
        count(*) as approved_count
    from
        client
        left join application on client.ID = application.client_id
        left join review on application.ID = review.application_id
    where
        status = 'approved'
    group by
        client_id
)
select
    client_review_in_progress.client_id,
    client_review_in_progress.name,
    rejected_count,
    approved_count,
    in_progress_count
from
    client_review_in_progress
    left join client_review_rejected on client_review_rejected.client_id = client_review_in_progress.client_id
    left join client_review_approved on client_review_in_progress.client_id = client_review_approved.client_id
union
select
    client_review_approved.client_id,
    client_review_approved.name,
    rejected_count,
    approved_count,
    in_progress_count
from
    client_review_approved
    left join client_review_rejected on client_review_rejected.client_id = client_review_approved.client_id
    left join client_review_in_progress on client_review_in_progress.client_id = client_review_approved.client_id
union
select
    client_review_rejected.client_id,
    client_review_rejected.name,
    rejected_count,
    approved_count,
    in_progress_count
from
    client_review_rejected
    left join client_review_in_progress on client_review_rejected.client_id = client_review_in_progress.client_id
    left join client_review_approved on client_review_rejected.client_id = client_review_approved.client_id;



-- shorten the last one
with client_application_review as (
    select
        client.ID as id,
        status
    from
        client
        left join application on client.ID = application.client_id
        left join review on application.ID = review.application_id
)

select
    id as client_id,
    (
        select
            count(*)
        from
            client_application_review
        where
            id = client_id
            and status = 'rejected'
    ) as rejected_count,
    (
        select
            count(*)
        from
            client_application_review
        where
            id = client_id
            and status = 'approved'
    ) as approved_count,
    (
        select
            count(*)
        from
            client_application_review
        where
            id = client_id
            and status = 'in progress'
    ) as in_progress_count
from
    client_application_review
group by
    id;