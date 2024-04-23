compare_results(Result, Expected) :-
    sort(Result, SortedResult),
    sort(Expected, SortedExpected),
    assertion(SortedResult =@= SortedExpected).