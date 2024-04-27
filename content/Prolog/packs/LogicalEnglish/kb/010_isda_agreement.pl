:- module('010+http://tests.com',[]).

en("the target language is: prolog.

the templates are:
	it is permitted that *an eventuality*,
   	*a party* gives notice to *a party* at *a time* that *a message*,
	*a party* designates at *a time* that *an eventuality*,
	the Schedule specifies that *an specification*,
	*an Event* of Default occurs with respect to *a party* at *a time*,
	*an event* occurs at *a time*,
	*an Event* is continuing at *a time*,
	*a date* is on or before *another date*,
	Automatic Early Termination applies to *a party* for *an Event* of Default,
	*a second time* is not more than *a number* days after *a first time*. 

the knowledge base permission includes:
it is permitted that a party designates at a time T2 that Early Termination in respect of all outstanding Transactions occurs at a time T3
if  an Event of Default occurs with respect to an other party at a time T1
and the Event is continuing at T2
and the party gives notice to the other party at T2 that the Event occurs at T1
and T2 is on or before T3 
and T3 is not more than 20 days after T2
and it is not the case that 
	the Schedule specifies that Automatic Early Termination applies to the other party for the Event of Default.
	

scenario one is:
	event001 of Default occurs with respect to Bob at Monday.
	event001 is continuing at Tuesday.
	Alice gives notice to Bob at Tuesday that event001 occurs at Monday.
	Tuesday is on or before Friday.
	Friday is not more than 20 days after Tuesday. 
    
query one is:
it is permitted that which party designates at which first time that which event occurs at which second time.
   
").

/** <examples>
?- answer("query one with scenario one").
*/
