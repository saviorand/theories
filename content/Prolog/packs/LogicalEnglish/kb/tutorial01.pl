:- module('tutorial01',[]).

en("the target language is: prolog.

the templates are: 
    *a person* is the author of *a document*.

the knowledge base first example includes:

Jacinto Dávila is the author of this document.

query one is: 
    which person is the author of this document.

query two is: 
    which person is the author of which document. 
    
").



/** <examples>
?- answer one. 
?- answer two. 
?- answer(one, with(noscenario), le(E), R).
*/
