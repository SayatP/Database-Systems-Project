create view client_public as
select
    first_name,
    last_name,
    city,
    country,
    email
from
    client;

create view client_application_review as (
    select
        email,
        application.text,
        status

    from
        client
        left join application on client.ID = application.client_id
        left join review on application.ID = review.application_id
);
