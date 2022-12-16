delimiter / / 
create procedure get_comments_of_application (application_id int) begin
select
    author_email,
    comment.`text`,
    comment.created_at
from
    application
    left join comment on comment.application_id = application.ID
where
    application.ID = application_id;

end / /
delimiter ;

delimiter / / 
create procedure approve_application (application_id int) begin
update
    review
set
    review.status = 'approved'
where
    review.application_id = application_id;

end  / / 
delimiter ;



delimiter / / 
create procedure calculate_service_budgets () begin
update
    service
set
    budget = (
        select
            sum(amount)
        from
            sponsorship
        where
            service_id = service.ID
        group by
            service_id
    );

end / / 
delimiter ;


select sum(budget) from service;
select sum(amount) from sponsorship;


delimiter //
create trigger sponsorship_insert
AFTER INSERT ON sponsorship FOR EACH ROW
begin
    update
        service
    set
        budget = budget + new.amount

    where
        service.ID = new.service_id;
end;
//
delimiter ;


select ID, budget from service where ID=2;
insert into sponsorship(donor_id, service_id, amount, created_at) values (1, 2, '5000.85', '2001-01-20 23:45:51');