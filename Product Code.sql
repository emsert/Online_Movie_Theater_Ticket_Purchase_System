--FINAL WORKING CODE of the DATABASE and FUNCTIONS:

--FEATURES:

set serveroutput on;

--Feature 1: DANIEL

Create or replace procedure get_registration
(v_name in varchar, v_email in varchar, v_address in varchar, v_password in varchar)
IS
v_count int;

Begin
	select count(*) into v_count from cuser where email = v_email;
	if v_count<=0 then
	insert into cuser values (SEQ_cuser.nextval, v_name, v_email, v_address, v_password);
    dbms_output.put_line('New User Created');
	Else
    dbms_output.put_line('User Already Exists');

--looks through the database to see if the inputted email matches an email in the db
--if so, the procedure will print ‘user exists’
--if not, the procedure will input a new user with the corresponding email

End if;
End;
/
Exec get_registration('John', 'john@theatre.edu', 'East street', 'John123');
--adds new user to the cuser table
/
Select * from cuser;

--Feature 2: DANIEL

Create or replace function get_user_login
(v_email in varchar, v_password in varchar)
return number
IS
v_count int;

Begin
select count(*) into v_count from cuser where email=v_email and password=v_password;
if v_count > 0 then
dbms_output.put_line('Successful Login');
return 1;
--it will look through the database to see if the inputted email and password match
--if so, the function will print ‘successful login’

else
dbms_output.put_line('Password and Email Did Not Match');
return 0;
--if email and password don’t match, then the function will print ‘will not match’

End if;
End;
/
Declare
v_count int;
Begin
v_count := get_user_login ('John@theatre.edu', 'John123');
if v_count <= 0 then
dbms_output.put_line('Please try again');
else
dbms_output.put_line('Welcome back');
End if;
End;
--if correct username and password is entered the system should display welcome msg
--if incorrect username and password, system says please try again

--Feature 3: DANIEL

 Create or replace procedure add_showtime
(v_cnid in int, v_aid in int, v_sTime in timestamp, v_mtype in int, v_mid in int, v_stype in int, v_sselection in int, v_sprice in number)
IS
v_count int;
v_count2 int;
v_count3 int;
v_atype int;
v_count4 int;
v_mlength interval day to second;
v_sid int;
v_count5 int;

Cursor c1 is select cnid, sid from seat_status where cnid=v_cnid and sid=v_sid;


Begin
select count(*) into v_count from movie where mid = v_mid;
if v_count<=0 then
dbms_output.put_line('Invalid Movie ID');
Else
dbms_output.put_line('Movie Exists');

--checks to determine if the movie exists by checking the movie id

select count(*) into v_count2 from aud_cinema where cnid = v_cnid and aid = v_aid;
if v_count2 <= 0 then
dbms_output.put_line('Invalid Auditorium ID or Cinema ID');
Else
dbms_output.put_line('Cinema Exists');

--checks to see if the provided cinema and auditorium id match
--error message will be printed if they don’t match in the db

select count(*) into v_count3 from movie
where mid = v_mid and mreleasedate <= v_sTime;
if v_count3 <= 0 then
dbms_output.put_line('Movie can be shown only after release');
Else
dbms_output.put_line('Movie can be shown');

--movie must be released before the start-time
--aggregation is used to determine that the start time is no earlier than the release time
--if not, error message will be printed

select atype into v_atype from auditorium
where auditorium.aid=v_aid;
if (v_atype != 3 and v_mtype = 3) or (v_atype != 2 and v_mtype = 2) or (v_mtype = 1 and v_atype = 3) then
dbms_output.put_line('Movie cannot be shown in this auditorium');
Else
dbms_output.put_line('Auditorium is available');

--1=regular, 2=3D, 3=IMAX
--v_atype and v_mtype must match
--checks to see that both types do match, if not then error message will be printed

select mlength into v_mlength from movie where mid = v_mid;

select count(*) into v_count4 from showing, movie, auditorium, cinema
where movie.mid=showing.mid and cinema.cnid=showing.cnid and auditorium.aid=showing.aid
and sTime=v_sTime and movie.mid=v_mid and auditorium.aid=v_aid and cinema.cnid=v_cnid and showing.cnid=v_cnid and mlength=v_mlength and not (v_sTime + v_mlength < sTime or sTime + mlength < v_sTime);

if v_count5 <= 0 then
dbms_output.put_line('There is a conflict');
Else
dbms_output.put_line('Show can be added');

--overlap
--compares the show’s end time (start time + length) to another show’s start time and compares the show’s start time to another show’s end time
--two shows cannot be overlapping, so this checks to see if the show is overlapping another
--if so, the show cannot be shown in that cinema and auditorium and there will be a conflict

Insert into showing VALUES
    (SEQ_showing.nextval,  trunc (v_stime), v_stime, v_stype, v_mid, v_aid, v_cnid, 0, v_sselection, v_sprice);
--will add the new show time into the showing table

for item in c1
loop
dbms_output.put_line(item.cnid || item.sid);
  --insert into seat_status VALUES (SEQ_seat_status.nextval, c_nid, SEQ_showing.currval, null, v_sselection);
--will insert seat availability information for the new show

End loop;

End if;
End if;
End if;
End if;
End if;

Exception
when no_data_found then
dbms_output.put_line('Seat is not available');

End;
/
Exec add_showtime (2, 2, timestamp '2019-07-17 13:00:00', 1, 1, 1, 1, 8);

-- should add new showtime to the showing table
Select * from showing;

--Feature 4: WILLIAM

Create or replace procedure Add_new_movie(m_Title in varchar, m_releasedate in date, M_Rating in int, Avg_IMDBscore in int, M_Length in  interval day to second)
IS
m_count int;
--does not require movie length to include all decimal 0s
Cursor c1 is select MTitle, mid from movie;

Begin

--Movie Checker
select count(*) into m_count from movie where mTitle = m_title;
If m_count > 0 then
	Dbms_output.put_line('Movie has already been inserted');
	--alert the user that their movie is already in the database
Else
    insert into movie values (SEQ_movie.nextval, m_Title,  m_releasedate, M_Rating, 0, Avg_IMDBscore, M_Length);
	Dbms_output.put_line('The new movie you inserted has an ID of: ' || SEQ_movie.currval);
	--alert the user that their movie has been added
End if;
End;
/
Exec Add_new_movie('Monty Python', date '1968-4-27', 5, 5, interval '0 2:40:00' DAY TO SECOND);
--adds movie to movie table
--check movie table
/
select * from movie






--Feature 5: ENES

create or replace procedure movie_times(m_title in varchar, the_date in date) is

title_check int;
date_check int;

cursor c1 is select cnname, stime, mtype, sfull
    	from movie m, showing s, cinema c
         	where
            	m.mid = s.mid and
            	c.cnid = s.cnid and
            	sdate = the_date
            	ORDER BY mtitle, cnname, mtype, stime ;
    	cr c1%rowtype;

    	begin
    	-- Count the number of movies that contains all/some parts of the movie title
    	Select count(*) into title_check from movie where mtitle like '%' || m_title || '%';

    	-- Count the number of showings on the date that is entered
    	Select count(*) into date_check from showing where sdate = the_date;

        	-- Title validation
        	If title_check = 0 then
            	Dbms_output.put_line('Error: There is no movie with that movie title.');

        	-- Date validation
        	elsif date_check = 0 then
            	Dbms_output.put_line('Error: There is no showtime for the movie on that date.');

        	-- Upon successful entry, print the movie details
        	else
            	open c1;
            	dbms_output.put_line('');
            	dbms_output.put_line('');
            	dbms_output.put_line('MOVIE TIMES:');
            	loop
                	fetch c1 into cr;
                	exit when c1%notfound;
                	dbms_output.put_line('');
                	dbms_output.put_line('> ' || 'Cinema Name: ' || cr.cnname ||  ' , Start Time: ' ||
                	cr.stime || ' , Movie Format: ' ||  cr.mtype ||  ' , Full Status: ' || cr.sfull);
            	end loop;
        	end if;
        	end;
/

-- Correct Entry  will show movie times
exec movie_times('Avenger', '17-JUL-19');

-- Date error  will say there are no movies for given date
exec movie_times('Avenger', '17-JUL-18');

-- Movie title error will say there is no movie for given title
exec movie_times('Fast and Furious', '17-JUL-19');





--Feature 6: WILLIAM

Create or replace procedure list_movie (c_name varchar, input_time timestamp )
As
cinema_check int;
time_check int;
--create new cursor & transfer the variables

Cursor c1 is select cnName, mtitle, stype, stime, sfull --create new cursor
From cinema c, movie m, showing s
Where s.mid = m.mid and
  	c.cnid = s.cnid and
  	cnname like '%' || c_name || '%' and
  	input_time <= stime;
	--join the tables

r c1%rowtype;

Begin
Select count(*) into cinema_check from cinema Where cnname like '%' || c_name || '%' ;
--finds all cinemas with matching cinema ids
Select count(*) into time_check from showing Where input_time < stime;
--finds all movie showing times

	If cinema_check = 0 then
		Dbms_output.put_line('No such cinema exists');
		--print when no matching cinema in result
	elsif time_check = 0 then
		Dbms_output.put_line('There is no movies to show at this time!');
		--print when no matching movie time in result
	else
    	open c1;
    	loop
        	fetch c1 into r;
        	exit when c1%notfound;
        	dbms_output.put_line(r.mtitle || ' ' || r.stype || ' ' || r.stime);
    	If r.sfull = 2
		Then dbms_output.put_line('this section is full');
		--alert user if desired section is sold out
Elsif r.sfull = 1
	Then dbms_output.put_line('this section is not full');
	--alert user if desired section is still open
	End if;
end loop;
	End if;
End;
/
exec list_movie('regal', '17-JUL-19 02.00.00.000000000 PM');
-- prints: No movies to show after this time

exec list_movie('regal', '17-JUL-19 02.00.00.000000000 AM');
-- prints: Avengers movie shows after this time and is not full


--Feature 7: JOSH

-- inputs are movie id, cinema id, show type (3D, Imax or regular as ints), and the time they would like
create or replace procedure display_Movie(m_id in int, c_nid in int, s_Type int, s_Time timestamp)
as
v_count int;
seat_count int;
 --first cursor selects output showing seat letter, number and show id
cursor c1 is select sm.scombined, showing.sid     --scombined is the seat id
from seatmap sm, Ticket tk, showing
where tk.tkid in (

 select tk1.tkid
from seatmap sm1, seatmap sm2, Ticket tk1, Ticket tk2, showing, movie m
where  sm1.scombined = tk1.scombined and tk1.tkid = tk2.tkid and tk2.scombined = sm2.scombined and m.mid = showing.mid
and tk2.sid = showing.sid and m.mid = m_id and sType = s_Type and tk2.cnid = c_nid and sTime = s_Time)
and tk.sid = showing.sid and ( tk.scombined != sm.scombined );
 --compares tickets for the show vs the default theatre layout and shows unoccupied seats

r c1%rowtype;
Begin
-- identifies whether or not there is a showing of given movie
 select count(showing.sid) into v_count from seatmap sm, Ticket tk, showing
where tk.tkid in (

 select tk1.tkid
from seatmap sm1, seatmap sm2, Ticket tk1, Ticket tk2, showing, movie m
where  sm1.scombined = tk1.scombined and tk1.tkid = tk2.tkid and tk2.scombined = sm2.scombined and  m.mid = showing.mid
and tk2.sid = showing.sid and m.mid = m_id and sType = s_Type and tk2.cnid = c_nid and sTime = s_Time)
and tk.sid = showing.sid and (tk.scombined != sm.scombined );

--checks whether there are any seats available
select count(sm.scombined) into seat_count from seatmap sm, Ticket tk, showing
where tk.tkid in (

 select tk1.tkid
from seatmap sm1, seatmap sm2, Ticket tk1, Ticket tk2, showing, movie m
where sm1.scombined = tk1.scombined  and tk1.tkid = tk2.tkid and tk2.scombined = sm2.scombined and  m.mid = showing.mid and
 tk2.sid = showing.sid and m.mid = m_id and sType = s_Type and tk2.cnid = c_nid and sTime = s_Time)
and tk.sid = showing.sid and (tk.scombined != sm.scombined);
 -- logic for whether movie is found
 if v_count = 0 then
  dbms_output.put_line('Movie not found');
 -- logic for if seats are full or not
elsif seat_count = 25 then
    dbms_output.put_line('Movie is full');
    update Ticket
    set issued = 2;

  else
    open c1;
dbms_output.put_line('Seats Available');
              	loop
                                	fetch c1 into r;
                                	exit when c1%notfound;
              	   dbms_output.put_line('  '|| r.scombined || '       	Show #' || r.sid);
	--runs through each seat
   	-- displays output if there is a showing and there are seats available
             -- output is string values of seats available
              	end loop;
 end if;

end;

/
-- examples of movies, both available and unavailable
exec display_Movie (3, 1, 3, '04-JUL-19 11.00.00.000000 AM');
 --shows available seats for movie
exec display_Movie (2, 1, 1, '10-JUN-19 06.00.00.000000 PM');
exec display_Movie (1, 3, 1, '17-JUL-19 01.00.00.000000 PM');

--Feature 8: JESSE
create or replace procedure buy_ticks(user_id int, cinema_id int, title varchar, time timestamp, format int, ad int, ch int, se int)
is
cnt int;
seats int;
show int;
base_price number;
ad_price number;
ch_price number;
se_price number;
tot_price number;
final_price number;
quant int;
aud int;
sel_tran int;
begin
-- check if user exists
select count(*) into cnt from cuser where cuid = user_id;
if cnt = 0 then
	dbms_output.put_line('No such user exists');
else
	-- check cinema id, movie title, start time, and format
	select count(*) into cnt
	from showing sh, movie m
	where sh.mid = m.mid and cinema_id = sh.cnid and mtitle like  ('%' || title || '%') and time = sh.stime and format = sh.stype;
	if cnt = 0 then
    	dbms_output.put_line('No matches for search criteria');
	elsif cnt > 1 then
    	dbms_output.put_line('Multiple matches, refine search');
	else
    	-- check if there are enough seats (capacity - sold) >= number needed
    	quant := ad + ch + se;
    	select numofseats into seats
    	from auditorium a, aud_cinema ac
    	where a.aid = ac.aid and cinema_id = ac.cnid;
    	select sh.sid into show
    	from showing sh, movie m
    	where sh.mid = m.mid and cinema_id = sh.cnid and mtitle like  '%' || title || '%' and time = sh.stime and format = sh.stype;
    	select count(*) into cnt
    	from ticket t
    	where show = t.sid;
    	if (seats - cnt) < quant then
        	dbms_output.put_line('Not enough available seats');
    	else
        	--create transaction
        	base_price := 10;
        	ad_price := (base_price) * ad;
        	se_price := (base_price *.9) * se;
        	ch_price := (base_price * .8) * ch;
        	tot_price := ((ad_price + se_price + ch_price));
        	final_price := (tot_price + (tot_price * .06) + (1.5 * quant));
        	insert into transact values(SEQ_transact.nextval, user_id, show, time, quant, 0, final_price);
        	-- print details
        	dbms_output.put_line('Adult: $' || base_price || ' X ' || ad || ' = $' || ad_price);
        	dbms_output.put_line('Senior: $' || (base_price *.9) || ' X ' || se || ' = $' || se_price);
        	dbms_output.put_line('Child: $' || (base_price * .8) || ' X ' || ch || ' = $' || ch_price);
        	dbms_output.put_line('Total: $' || tot_price || ' + $' || (1.5 * quant) || ' Fee + $' || (tot_price * .06) || ' Tax = $' || final_price);
        	-- create tickets
        	select aid into aud
        	from aud_cinema ac
        	where cinema_id = ac.cnid;
        	for i in 1..ad loop
            	insert into Ticket values(SEQ_ticket.nextval, SEQ_transact.currval, 1, base_price, NULL, 1, user_id, show, cinema_id, aud);
        	end loop;
        	for i in 1..ch loop
            	insert into Ticket values(SEQ_ticket.nextval, SEQ_transact.currval, 2, (base_price * .8), NULL, 1, user_id, show, cinema_id, aud);
        	end loop;
        	for i in 1..se loop
            	insert into Ticket values(SEQ_ticket.nextval, SEQ_transact.currval, 3, (base_price * .9), NULL, 1, user_id, show, cinema_id, aud);
        	end loop;
        	-- check if showing is now full
        	if (cnt + quant) = seats then
            	update showing
            	set sfull = 2
            	where sid = show;
            	dbms_output.put_line('');
            	dbms_output.put_line('The tickets have been created.');
            	dbms_output.put_line('The show is now full!');
        	else
            	dbms_output.put_line('');
            	dbms_output.put_line('Tickets created.');
        	end if;
    	end if;
	end if;
end if;
end;
/

exec buy_ticks(1, 2, 'The Avenger', timestamp '2019-07-17 13:00:00', 1, 1, 2, 1);
/
Select * from transact;
Select * from ticket;
-- creates transaction in transact table & creates each ticket

--Feature 9: JESSE
create or replace type seat_list_type as varray(30) of varchar2(4);
/

create or replace procedure select_seat(tran_id int, seat seat_list_type)
is
cursor c2 is select tkid from ticket ti where tid = tran_id;
cnt int;
selected_seat int;
selectable int;
tran_num int;
seat_list_num int;
avail int;
i int;
begin
-- check in transaction exists
select count(*) into cnt from transact where transact.tid = tran_id;
if cnt = 0 then
	dbms_output.put_line('Transaction does not exist');
else
	-- check if the movie allows seat selection
	select sselection into selectable
	from showing s, transact t
	where t.sid = s.sid and t.tid = tran_id;
	if selectable = 1 then
    	dbms_output.put_line('');
    	dbms_output.put_line('This showing does not have selectable seating!');
	else
    	--check if array size equals quantity of tickets in transaction
    	select tquantity into tran_num from transact where transact.tid = tran_id;
    	seat_list_num := seat.count;
    	if seat_list_num != tran_num then
        	dbms_output.put_line('Number of selected tickets and number of tickets in transaction do not match');
    	else
        	--check if input seats are available
        	avail := 1;
        	for i in 1..seat.count loop
            	select count(*) into cnt
            	from Ticket ti,  showing s
            	where ti.sid = s.sid and ti.scombined like seat(i);
            	if cnt = 1 then
                	dbms_output.put_line('Seat ' || seat(i) || ' is not available');
                	avail := 0;
                	exit;
            	end if;
        	end loop;
        	if avail = 1 then
        	-- assign seats to tickets in transaction
			-- c2 is a explicit cursor selecting all tickets in input transaction
			i:=1;
			for r in c2 loop
				Update ticket set scombined = seat(i) where tkid = r.tkid;
				i:=i+1;
				Exit when i > seat.count;
			end loop;
    	end if;
	end if;
end if;
end if;
end;
/

exec select_seat(4, seat_list_type('A2', 'A3', 'A4', 'A5'));
/
-- selects seating for user
-- check ticket table for ticket assignment
Select * from ticket;


--Feature 10: JESSE
create or replace procedure pay(tran_id int, method int, pnum int, amt number)
is
cnt int;
alrdy_paid number;
amt_due number;
cust_id int;
show_id int;
begin
-- check if transaction exists
select count(*) into cnt from transact where tid = tran_id;
if cnt = 0 then
	dbms_output.put_line('Invalid transaction ID');
else
	--check if the payment is already paid or not
	select ttotal into amt_due
	from transact
	where tid = tran_id;
	select nvl(sum(Amount),0) into alrdy_paid
	from Payment
	where tid = tran_id;
	if alrdy_paid = amt_due then
    	dbms_output.put_line('The transaction is already paid');
	else
    	--check if the new payment + existing payment reaches the total
    	select cuid into cust_id from transact where tid = tran_id;
    	select sid into show_id from transact where tid = tran_id;
    	if (alrdy_paid + amt) >= amt_due then
        --create a full payment
     	dbms_output.put_line('Full Amount Paid');
        	update transact
        	set tstatus = 1
        	where tid = tran_id;
        	update Ticket
        	set issued = 2
        	where tkid in (select tkid from ticket where tid = tran_id);
        	insert into Payment values(SEQ_Payment.nextval, pnum, show_id, tran_id, cust_id, 1, method, (amt_due - alrdy_paid), systimestamp);
    	else
        --create a partial payment
     	dbms_output.put_line('Partial Amount Paid');
        	update transact
        	set tstatus = 0
        	where tid = tran_id;
         	insert into Payment values(SEQ_Payment.nextval, pnum, show_id, tran_id, cust_id, 1,  method, (amt), systimestamp);
    	end if;
	end if;
end if;
end;
/
--creates payment for a transaction

exec pay(4, 2, 7643, 43.46);
/
Select * from payment
Select * from transact
--check these tables for the payment item and the updated transaction
/


--Feature 11: ENES

create or replace procedure cancel_purchase(t_id in number, current_time in timestamp) is

tid_check int;

cursor c1 is select s.stime, t.tstatus, p.pnum, p.sid, p.cuid, p.amount, sysdate, pmethod, ptype
    	from transact t, showing s, payment p, SYS.dual
         	where
            	s.sid = t.sid and
            	t.tid = p.tid and
            	t.tid = t_id;

    	cr c1%rowtype;

begin


-- Count the number of transactions with the ID that is entered
select count(*) into tid_check from transact where tid = t_id;

	open c1;

	loop
    	fetch c1 into cr;
    	exit when c1%notfound;

-- User ID validation
	if tid_check = 0 then
    	dbms_output.put_line('There is no related information with this User ID.');


--Movie already started error
	elsif  current_time >= cr.stime  then
   	dbms_output.put_line('Error: You cannot cancel the ticket because the movie already started.');


 --Last 30 minutes error
	elsif  (current_time + (.000694 * 30)) > cr.stime  then
   	dbms_output.put_line('Error: You cannot cancel the ticket because there is less than 30 minutes left for showing.');


-- Ticket already canceled error
	elsif  cr.tstatus = 2 then
   	dbms_output.put_line('Error: The ticket has already been canceled.');


-- Check whether the transaction has been paid and insert for each payment record
	elsif cr.tstatus = 1 and cr.ptype = 1 then
    	insert into payment values(SEQ_Payment.nextval, cr.pnum, cr.sid, t_id, cr.cuid, 2, cr.pmethod, (-1 * cr.amount), sysdate);



-- Mark the transaction as canceled
update transact
set tstatus = 2
where tid = t_id;


-- Delete related tickets. NOTE: Assigned seats will be available by default since it is an attribute in the ticket object.
delete from ticket
where tid = t_id;

-- After all processes are done, print a message to inform user about the return status.
	dbms_output.put_line('');
	dbms_output.put_line('Return has been processed successfully!');
	end if;
	end loop;
end;
/

-- MOVIE STARTS AT 1PM

-- Movie already started error
exec cancel_purchase(1, '17-JUL-19 01.00.00.000000000 PM');

-- Less than 30 minutes error
exec cancel_purchase(1, '17-JUL-19 12.31.00.000000000 PM');

-- Valid cancellation
exec cancel_purchase(1, '17-JUL-19 12.29.00.000000000 PM');

--Feature 12: JOSH

create or replace procedure create_Review(c_uid in int, c_nid in int, m_id in int, R_score int, R_vw varchar)
as
u_count int; --checks whether user exists
c_count int; --checks whether cinema exists
s_count int; --checks whether score is between 1 and 5

r_count int;
r Review%rowtype;
begin
 select count(u.cuid) into u_count from cuser u, cinema c, Review r
where u.cuid = c_uid; -- logic for user existing

select count(u.cuid) into c_count from cuser u, cinema c, Review r
where c.cnid = c_nid; -- logic for cinema existing

select count(u.cuid) into s_count from cuser u, cinema c, Review r
where R_score > 0 and R_Score <6;  --logic for score between 1 and 5

 --checks to make sure user has not posted to the same cinema within 30 days
select count(r.cuid) into r_count from Review r
where r.cuid = c_uid and r.cnid = c_nid and Time_date >= TRUNC(SYSDATE) - 30;
 -- logic and output checks for each variable
 if u_count = 0 then
  dbms_output.put_line('User invalid');

elsif c_count = 0 then
	dbms_output.put_line('Cinema invalid');
elsif s_count = 0 then
	dbms_output.put_line('Rating must be between 1 and 5 stars');
elsif r_count > 0 then
	dbms_output.put_line('Must wait at least 30 days after last review for this cinema');
  Else -- output if review satisfies all requirements
--review is then inserted into Review table
   	dbms_output.put_line('Review successfully posted');
              	insert into Review values(SEQ_Review.nextval, c_uid, c_nid, m_id, R_score, R_vw, CURRENT_TIMESTAMP);
end if;



end;

/
exec create_Review(1, 1, 1, 5, 'Movie was a movie so good. I like movies');

exec create_Review(2, 1, 1, 5, 'I like that cinema'); -- if review is correct, posts review to review  --Review table

exec create_Review(3, 3, 1, 5, 'What a Kino!');
--creates review if correct information is given (valid user etc.)
--check review table
/
Select * from Review



--Feature 13: WILLIAM

create or replace procedure movie_stats(m_id integer, start_date date, end_date date) as

--total ticket sales
--declare procedure variables
Total_ticket_sales number;
	Occupancy_rate number;
	Max_tickets number;
	mtitle varchar(55);
    seat_count number;
    tickets_bought number;
    number_of_shows number;
    transact_total number;

    Begin

    select count(*) as tickets_bought, transact.ttotal as transact_total, count(movie.mid) as number_of_shows into tickets_bought, transact_total,
Number_of_shows
from transact, Ticket, showing, movie
where   movie.mid = m_id and
        showing.mid = movie.mid and
		showing.sid = ticket.sid and
        transact.tid = Ticket.tid and
    	trunc(ttime)>= start_date and
    	trunc(ttime)<= end_date
    	group by movie.mid, transact.ttotal;
--create joins & transfer variables

select count(sm.scombined) into seat_count from seatmap sm, Ticket tk, showing
where tk.tkid in (

 select tk1.tkid
from seatmap sm1, seatmap sm2, Ticket tk1, Ticket tk2, showing, movie m
where sm1.scombined = tk1.scombined  and tk1.tkid = tk2.tkid and tk2.scombined = sm2.scombined and  m.mid = showing.mid and
 tk2.sid = showing.sid)
and tk.sid = showing.sid and (tk.scombined != sm.scombined);

--store equations into variables
    Total_ticket_sales := (tickets_bought * number_of_shows) * transact_total;
    Occupancy_rate := (seat_count/ (number_of_shows * 25));


 if mtitle = null then
 dbms_output.put_line('The movie title entered is not valid.');
   else

  dbms_output.put_line('');
dbms_output.put_line('');
dbms_output.put_line('MOVIE STATISTICS:');
dbms_output.put_line('');
dbms_output.put_line('1) Total ticket sales is: $' || Total_ticket_sales);
dbms_output.put_line('2) Occupancy rate is: ' || Occupancy_rate);
  end if;

END;
/
exec movie_stats(2, '26-FEB-10', '26-FEB-20');
--prints: Total ticket sales & Occupancy rate



--Feature 14: WILLIAM

create or replace procedure cinema_stats(cn_id integer, start_date date, end_date date) as
 --declare procedure variables
	Total_tickets integer;
	Total_ticket_sales number;
	Occupancy_rate number(10,2);
	Max_tickets number;
	mtitle varchar(55);
    seat_count number;
    tickets_bought number;
    number_of_shows number;
    transact_total number;
	Review_score number;
	CnName varchar(30);
	AvgIMDBscore number;
    AvgUserReview number;

    Begin

--total ticket sales
    select count(*) as tickets_bought, count(movie.mid) as number_of_shows, transact.ttotal as transact_total,
    movie.avgimdbscore as AvgIMDBscore into tickets_bought, transact_total, AvgIMDBscore,
number_of_shows
from transact, Ticket, showing, movie, cinema
where   cinema.cnid = cn_id and
        showing.mid = movie.mid and
		showing.sid = ticket.sid and
        transact.tid = Ticket.tid and
		cinema.cnid = showing.cnid and
    	trunc(ttime)>= start_date and
    	trunc(ttime)<= end_date
    	group by cinema.cnid, transact.ttotal, movie.avgimdbscore;
        --perform joins

            select cast(avg(Rscore) as decimal(10,2))  into avgUserReview
	--Average Review has 2 decimal places
from transact, Ticket, showing, cinema, Review
where   cinema.cnid = cn_id and
		showing.sid = ticket.sid and
        transact.tid = Ticket.tid and
		cinema.cnid = showing.cnid and
    	trunc(ttime)>= start_date and
    	trunc(ttime)<= end_date
    	;
--create additional joins

select count(sm.scombined) into seat_count from seatmap sm, Ticket tk, showing
where tk.tkid in (

 select tk1.tkid
from seatmap sm1, seatmap sm2, Ticket tk1, Ticket tk2, showing, movie m
where sm1.scombined = tk1.scombined  and tk1.tkid = tk2.tkid and tk2.scombined = sm2.scombined and  m.mid = showing.mid and
 tk2.sid = showing.sid)
and tk.sid = showing.sid and (tk.scombined != sm.scombined);

--store equations into variables
	Total_tickets := (tickets_bought * number_of_shows);
    Total_ticket_sales := (tickets_bought * number_of_shows) * transact_total;
    Occupancy_rate := (seat_count/ (number_of_shows * 25));

          --determine output specifications
 if CnName = null then
 dbms_output.put_line('The cinema ID entered is not valid.');
   else

dbms_output.put_line('');
dbms_output.put_line('');
dbms_output.put_line('CINEMA STATISTICS:');
dbms_output.put_line('');
dbms_output.put_line('1) Total tickets sold is: ' || Total_tickets);
--list the number of tickets sold
dbms_output.put_line('2) Total ticket sales (in dollars) is $' || Total_ticket_sales);
--list the total value of all sold tickets
dbms_output.put_line('3) Occupancy rate is: ' || Occupancy_rate);
--list the occupancy rate
dbms_output.put_line('4) Average IMDB Review Score is: ' || AvgIMDBscore );
--list the average imdb score
dbms_output.put_line('5) Average User Review Score is: ' || avgUserReview  );
--list the average user review score

  end if;

END;
/

exec cinema_stats(2, '26-FEB-10', '26-FEB-20');
--prints: # of tickets sold, Total sales, Occupancy rate, and Avg Review Scores



--Feature 15: ENES

create or replace procedure computer_stats(c_uid number, start_date date, end_date date) is

user_valid cuser.cuid%type;
Paid_Transactions int;
tickets_bought int;
Number_Transaction number;
Canceled_Transactions int;
the_cinema varchar2(99);
transaction_total number;

begin
-- User id validation
select nvl(count(*),0) into user_valid
from cuser
where cuid = c_uid;

if  user_valid = 0 then
	dbms_output.put_line('The user ID entered is not valid.');

else

-- Number of paid transactions
select count(*) as Paid_Transactions into Paid_Transactions
from transact t, payment p, cuser c
where   tstatus = 1 and
    	c.cuid = c_uid and
    	t.tid = p.tid and
    	c.cuid = p.cuid and
    	trunc(ttime)>= start_date and
    	trunc(ttime)<= end_date;



-- Number of tickets bought, and the total money spent for the tickets that are bought
select count(*) as Tickets_Bought, tra.ttotal as Total_Money_Spent into tickets_bought, transaction_total
from transact tra, ticket tic, cuser c
where   c.cuid = c_uid and
    	tra.cuid = c.cuid and
    	c.cuid = tic.cuid and
    	trunc(ttime)>= start_date and
    	trunc(ttime)<= end_date
    	group by c.cuid, tra.ttotal;


-- Number of canceled transactions,
select count(*) as Canceled_Transactions into Canceled_Transactions
from transact t, payment p, cuser c
where   tstatus = 2 and
    	c.cuid = c_uid and
    	t.tid = p.tid and
    	c.cuid = p.cuid and
    	trunc(t.ttime)>= start_date and
    	trunc(t.ttime)<= end_date;



-- The most frequently visited cinema (with the maximal number of paid transactions).
select cnname as Cinema, count(*) as Number_Transaction into the_cinema, Number_Transaction
from cinema cin, transact t, cuser cus, payment p, showing s
where   cus.cuid = c_uid and
    	cin.cnid = s.cnid and
    	cus.cuid = p.cuid and
    	t.tid = p.tid and
    	trunc(ttime)>= start_date and
    	trunc(ttime)<= end_date
    	group by cnname
	having count(*) = (select max(count(*))
	from cinema cin, transact t, cuser cus, payment p, showing s
	where   cus.cuid = c_uid and
        	cin.cnid = s.cnid and
        	cus.cuid = p.cuid and
        	t.tid = p.tid and
        	trunc(ttime)>= start_date and
        	trunc(ttime)<= end_date
        	group by cnname);


-- Computer Statistics
dbms_output.put_line('');
dbms_output.put_line('');
dbms_output.put_line('COMPUTER STATISTICS:');
dbms_output.put_line('');
dbms_output.put_line('1) Number of paid transactions: ' || Paid_Transactions);
dbms_output.put_line('2) Number of tickets bought is ' || tickets_bought || ', and the total money spent for the tickets is $' || transaction_total);
dbms_output.put_line('3) Number of canceled transactions: ' || Canceled_Transactions);
dbms_output.put_line('4) The most frequently visited cinema is ' || the_cinema ||
                 	', and its maximal number of paid transactions is ' || Number_Transaction);
end if;
END;
/

-- Success
exec computer_stats(2, '26-FEB-10', '26-FEB-20');

-- User ID failure
exec computer_stats(99, '26-FEB-10', '26-FEB-20');


--Feature 16: JOSH
create or replace procedure identify_bad_reviews( rchar int)
As
cursor c1 is select rid from Review;

 -- user input is min char limit
--cursor gets all Reviews

r c1%rowtype;
begin

 --checks whether review is less than “rchar” characters and if score less than or greater than
--lwrbnd and uprbnd respectively

  FOR c1 IN (SELECT Review.rid
            	FROM Review
           	WHERE length(Rvw) < rchar)
           	loop

 --prints violation if Review satisfies the two conditions
           	dbms_output.put_line( 'Invalid Review #:'||c1.rid|| '	Violation: Too few characters');


           	END loop;

--checks whether user has purchased ticket from cinema in the review
  FOR c1 IN (SELECT Review.rid

            	FROM Review
           	WHERE rid in (select Review.rid From

           	Review, cinema, Ticket, cuser where
           	Ticket.cuid != Review.cuid and Ticket.cnid = Review.cnid))

           	Loop

           	dbms_output.put_line( 'Invalid Review #:'||c1.rid||'	Violation: User has not bought ticket at cinema');
           	END loop;
 -- prints violation where user has not bought ticket

end;

/
 exec identify_bad_reviews(10);
-- displays all reviews that violate conditions




--NEW / UPDATED CREATES AND INSERTS
--*A missing column, Pmethod, is added to PAYMENT table.

Drop table cuser cascade constraints;
Drop table company cascade constraints;
Drop table movie cascade constraints;
Drop table auditorium cascade constraints;
Drop table Payment cascade constraints;
Drop table cinema cascade constraints;
Drop table aud_cinema cascade constraints;
Drop table seatmap cascade constraints;
Drop table seat_status cascade constraints;
Drop table Ticket cascade constraints;
Drop table showing cascade constraints;
Drop table transact cascade constraints;
Drop table Review cascade constraints;

Drop sequence SEQ_cuser;
Drop sequence SEQ_company;
Drop sequence SEQ_movie;
Drop sequence SEQ_auditorium;
Drop sequence SEQ_Payment;
Drop sequence SEQ_cinema;
Drop sequence SEQ_aud_cinema;
Drop sequence SEQ_seatmapA;
Drop sequence SEQ_seatmapB;
Drop sequence SEQ_seatmapC;
Drop sequence SEQ_seatmapD;
Drop sequence SEQ_seatmapE;
Drop sequence SEQ_seat_status;
Drop sequence SEQ_Ticket;
Drop sequence SEQ_showing;
Drop sequence SEQ_transact;
Drop sequence SEQ_Review;

create table cuser (
 	cuid int,
 	name varchar(30),
 	email varchar(30),
	address varchar(50),
 	password varchar(30),
 	primary key (cuid)
 	);

CREATE SEQUENCE SEQ_cuser

START WITH 1

INCREMENT BY 1;


insert into cuser
values(SEQ_cuser.nextval,'ludwig', 'ludwig@theatre.edu', 'North street', 'ludwig123');

insert into cuser
values(SEQ_cuser.nextval,'thomas', 'thomas@theatre.edu', 'South street','thomas123');

insert into cuser
values(SEQ_cuser.nextval,'john', 'john@theatre.edu', 'East street', 'john123');

create table company (
 	coid int,
 	coName varchar(30),
 	coAddress varchar(30),
 	coPhone int,
 	coAuditoriums int,
 	primary key (coid)
 	);

CREATE SEQUENCE SEQ_company

START WITH 1

INCREMENT BY 1;

insert into company
values(SEQ_company.nextval,'regal', 'Theatre street', 123456, 5);

insert into company
values(SEQ_company.nextval,'rex', 'Cinema street', 23445, 2);

insert into company
values(SEQ_company.nextval,'king', 'Main street', 99876, 6);

create table movie(
mid int,
mtitle varchar(55),
mreleasedate date,
mrating int,
mtype int,
avgIMDBscore number,
mlength interval day to second,
primary key (mid)
);
 CREATE SEQUENCE SEQ_movie

START WITH 1

INCREMENT BY 1;


insert into movie
values (SEQ_movie.nextval, 'The Avengers, Infinity War', date '2018-4-27', 2, 2, 8.5, interval '0 2:40:00' DAY TO SECOND);

insert into movie
values (SEQ_movie.nextval, 'How To Train Your Dragon 3', date '2019-02-22', 1, 2, 7.9, interval '0 2:40:00' DAY TO SECOND);

insert into movie
values (SEQ_movie.nextval, 'Forrest Gump', date '1994-7-6', 2, 2, 8.8, interval '0 02:22:00' DAY TO SECOND);

insert into movie
values (SEQ_movie.nextval, 'Gladiator', date '2018-4-27', 2, 2, 8.5, interval '0 2:40:00' DAY TO SECOND);

create table auditorium (
 	aid int,
 	aType int,
 	aName varchar(30),
 	numOfSeats int,
 	primary key (aid)
 	);

CREATE SEQUENCE SEQ_auditorium

START WITH 1

INCREMENT BY 1;

insert into auditorium
values(SEQ_auditorium.nextval, 1, 'Theatre 1', 25);

insert into auditorium
values(SEQ_auditorium.nextval, 1, 'Theatre 2', 25);

insert into auditorium
values(SEQ_auditorium.nextval, 3, 'Theatre 3', 10);

create table cinema (
 	cnid int,
 	coid int,
 	cnName varchar(30),
 	cnAddress varchar(30),
 	cnPhone int,
 	primary key (cnid),
 	foreign key (coid) references company(coid)
 	);
CREATE SEQUENCE SEQ_cinema

START WITH 1

INCREMENT BY 1;

insert into cinema
values(SEQ_cinema.nextval, 3, 'king Baltimore', 'main street', 665578);

insert into cinema
values(SEQ_cinema.nextval, 1,'regal Baltimore', 'west street', 098169);

insert into cinema
values(SEQ_cinema.nextval, 2, 'rex Baltimore', 'east street', 021118);

create table aud_cinema (
 	aid int,
 	cnid int,
 	primary key (aid, cnid),
 	foreign key (aid) references auditorium(aid),
 	foreign key (cnid) references cinema(cnid)
);

CREATE SEQUENCE SEQ_aud_cinema

START WITH 1

INCREMENT BY 1;

insert into aud_cinema
values(SEQ_aud_cinema.nextval, 2);

insert into aud_cinema
values(SEQ_aud_cinema.nextval, 1);

insert into aud_cinema
values(SEQ_aud_cinema.nextval, 1);

create table showing (
 	sid int,
 	sDate date,
 	sTime timestamp,
 	sType int,
 	mid int,
 	aid int,
 	cnid int,
 	sFull int,
 	sSelection int,
 	sPrice number,
 	primary key (sid),
 	foreign key (mid) references movie(mid),
 	foreign key (aid) references auditorium(aid),
 	foreign key (cnid) references cinema(cnid)
 	);

CREATE SEQUENCE SEQ_showing

START WITH 1

INCREMENT BY 1;

insert into showing
values (SEQ_showing.nextval, date '2019-07-17', timestamp '2019-07-17 13:00:00',1, 1, 1, 2, 1, 2, 8.00);

insert into showing
values (SEQ_showing.nextval, date '2019-06-10', timestamp '2019-06-10 18:00:00',1, 2, 2, 1, 1, 2, 10.00);

insert into showing
values (SEQ_showing.nextval, date '2019-07-04', timestamp '2019-07-04 11:00:00',3, 3, 3, 1, 1, 2, 15.00);

insert into showing
values (SEQ_showing.nextval, date '2019-07-04', timestamp '2019-07-04 11:00:00',4, 3, 3, 1, 1, 2, 15.00);

create table seatmap(
sletter varchar(2),
snumber int,
scombined varchar2(5),
primary key (scombined)
);
CREATE SEQUENCE SEQ_seatmapA

START WITH 1

INCREMENT BY 1;

CREATE SEQUENCE SEQ_seatmapB

START WITH 1

INCREMENT BY 1;

CREATE SEQUENCE SEQ_seatmapC

START WITH 1

INCREMENT BY 1;
CREATE SEQUENCE SEQ_seatmapD

START WITH 1

INCREMENT BY 1;

CREATE SEQUENCE SEQ_seatmapE

START WITH 1

INCREMENT BY 1;



insert into seatmap
values ('A', SEQ_seatmapA.nextval, 'A1'  );

insert into seatmap
values ('A', SEQ_seatmapA.nextval, 'A2' );

insert into seatmap
values ('A', SEQ_seatmapA.nextval, 'A3' );

insert into seatmap
values ('A', SEQ_seatmapA.nextval, 'A4' );

insert into seatmap
values ('A', SEQ_seatmapA.nextval, 'A5' );

insert into seatmap
values ('B', SEQ_seatmapB.nextval, 'B1'  );

insert into seatmap
values ('B', SEQ_seatmapB.nextval, 'B2' );

insert into seatmap
values ('B', SEQ_seatmapB.nextval, 'B3' );

insert into seatmap
values ('B', SEQ_seatmapB.nextval, 'B4' );

insert into seatmap
values ('B', SEQ_seatmapB.nextval, 'B5' );

insert into seatmap
values ('C', SEQ_seatmapC.nextval, 'C1'  );

insert into seatmap
values ('C', SEQ_seatmapC.nextval, 'C2' );

insert into seatmap
values ('C', SEQ_seatmapC.nextval, 'C3' );

insert into seatmap
values ('C', SEQ_seatmapC.nextval, 'C4' );

insert into seatmap
values ('C', SEQ_seatmapC.nextval, 'C5' );

insert into seatmap
values ('D', SEQ_seatmapD.nextval, 'D1'  );

insert into seatmap
values ('D', SEQ_seatmapD.nextval, 'D2' );

insert into seatmap
values ('D', SEQ_seatmapD.nextval, 'D3' );

insert into seatmap
values ('D', SEQ_seatmapD.nextval, 'D4' );

insert into seatmap
values ('D', SEQ_seatmapD.nextval, 'D5' );

insert into seatmap
values ('E', SEQ_seatmapE.nextval, 'E1'  );

insert into seatmap
values ('E', SEQ_seatmapE.nextval, 'E2' );

insert into seatmap
values ('E', SEQ_seatmapE.nextval, 'E3' );

insert into seatmap
values ('E', SEQ_seatmapE.nextval, 'E4' );

insert into seatmap
values ('E', SEQ_seatmapE.nextval, 'E5' );


create table seat_status (
ssid int,
cnid int,
sid int,
scombined varchar(5),
s_availability int,
primary key (ssid),
Foreign key (scombined) references seatmap (scombined),
foreign key (cnid) references cinema (cnid),
foreign key (sid) references showing (sid)
);

CREATE SEQUENCE SEQ_seat_status
	START WITH 1
	INCREMENT BY 1;

insert into seat_status
values (SEQ_seat_status.nextval, 1, 2, 'A3', 1);

insert into seat_status
values (SEQ_seat_status.nextval, 3, 1, 'C5', 1);

insert into seat_status
values (SEQ_seat_status.nextval, 2, 3, 'E4', 0);


create table transact (
 	tid int,
 	cuid int,
 	sid int,
 	tTime timestamp,
 	tQuantity int,
 	tStatus int,
 	tTotal number,
 	primary key (tid),
 	foreign key (cuid) references cuser(cuid),
 	foreign key (sid) references showing(sid)
 	);

CREATE SEQUENCE SEQ_transact

START WITH 1

INCREMENT BY 1;

insert into transact
values(SEQ_transact.nextval, 1, 1, timestamp '2019-04-22 11:57:34', 2, 1, 20.14);
-- price is based on ((ticket price + 1.5 fee) * # purchased) * 1.06 tax
-- assumes everyone is an adult with no discounts

insert into transact
values(SEQ_transact.nextval, 2, 2, timestamp '2019-06-03 14:02:04', 3, 0, 36.57);

insert into transact
values(SEQ_transact.nextval, 3, 3, timestamp '2019-07-03 08:22:42', 1, 0, 17.49);


create table Ticket (
	TKID int,
	tid int, --FK
	Ttype int, -- 1=adult, 2=child, 3=senior
Tprice number,
scombined varchar2(5), --FK
Issued int, --1=no, 2=yes
cuid int, --FK
sid int, --FK
cnid int, --FK
aid int, --FK
	primary key (tkid),
foreign key (tid) references transact(tid),
foreign key (scombined) references seatmap(scombined),
foreign key (cuid) references cuser(cuid),
foreign key (sid) references showing(sid),
foreign key (cnid) references cinema(cnid),
foreign key (aid) references auditorium(aid)
);


CREATE SEQUENCE SEQ_Ticket

START WITH 1

INCREMENT BY 1;

insert into Ticket
values(SEQ_Ticket.nextval, 1, 3, 9.99, 'A1', 2, 2, 3, 2, 1);

insert into Ticket
values(SEQ_Ticket.nextval, 2, 1, 12.99, 'B1', 2, 1, 2, 1, 2);

insert into Ticket
values(SEQ_Ticket.nextval, 3, 2, 6.99, 'C1', 1, 3, 1, 3, 3);


create table Payment (
	pid int,
	Pnum int,
sid int, --FK
tid int, --FK
cuid int, --FK
Ptype int, -- 1=payment, 2=refund
Pmethod int, -- 1=cash, 2=credit card, 3=gift card
Amount Number,
Ptime timestamp,
	primary key (pid),
	foreign key (sid) references showing(sid),
foreign key (tid) references transact(tid),
foreign key (cuid) references cuser(cuid)
);

CREATE SEQUENCE SEQ_Payment

START WITH 1

INCREMENT BY 1;

insert into Payment
values(SEQ_Payment.nextval, 1209, 2, 3, 1, 1, 2, 10.00, timestamp '2019-04-27 02:17:34');

insert into Payment
values(SEQ_Payment.nextval, 2859, 3, 1, 2, 1, 3, 5.00, timestamp '2019-02-22 09:57:00');

insert into Payment
values(SEQ_Payment.nextval, 3328, 1, 2, 3, 1, 1, 2.00, timestamp '2018-10-22 11:00:01');






create table Review (
 	rid int,
cuid int, --FK
cnid int, --FK
mid int, --FK
Rscore int,
Rvw varchar2(500),
Time_date timestamp,
 	primary key (rid),
 	foreign key (cuid) references cuser(cuid),
 	foreign key (mid) references movie(mid),
foreign key (cnid) references cinema(cnid)
);

CREATE SEQUENCE SEQ_Review

START WITH 1

INCREMENT BY 1;

Insert into Review
values (SEQ_Review.nextval, 3, 3, 1,  4, 'It was a fun movie to watch, but I expected more from the filmmaker, of course.', CURRENT_TIMESTAMP);

Insert into Review
values (SEQ_Review.nextval, 1, 2, 1, 2, 'Waste of time! Do not even consider going to this movie.', CURRENT_TIMESTAMP);

Insert into Review
values (SEQ_Review.nextval, 2, 2, 3,  5, 'My favorite movie so far. Gotta love the end!', CURRENT_TIMESTAMP);


Insert into Review
values (SEQ_Review.nextval, 2, 2, 3,  5, 'hi', CURRENT_TIMESTAMP);
