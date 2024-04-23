expected_model(ExpectedM) :-
    ExpectedM = [].

compare_results(Result, Expected) :-
    sort(Result, SortedResult),
    sort(Expected, SortedExpected),
    assertion(SortedResult =@= SortedExpected).