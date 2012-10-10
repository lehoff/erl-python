-module(test_fds).
-compile([export_all]).

count() ->
    count(1, []).

count(N, Fds) ->
    case file:open(integer_to_list(N), [write]) of
	{ok, F} ->
	    count(N+1, [F| Fds]);
	{error, Err} ->
	    [ file:close(F) || F <- Fds ],
	    {Err, N}
    end.
