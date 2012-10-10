-module(bucket_filler).

-export([fill/2]).
-export([fill/1]).

create_buckets(N) when is_integer(N), N > 0 ->
    PortsList = [ create_bucket()
                  || _ <- lists:seq(1, N) ],
    array:from_list(PortsList).

send_to_bucket(Buckets, N, Msg) ->
    Bucket = array:get(N, Buckets),
    port_command(Bucket, term_to_binary(Msg)).

fill_bucket(Buckets, N, M) ->
    %% io:format("fill_bucket(..., ~p, ~p)~n",
    %%           [N, M]),
    B = M rem N,
    send_to_bucket(Buckets, B, M).

create_bucket() ->
    open_port({spawn, "python -u bucket.py"},
                [{packet, 4}, binary, {env, [{"PYTHONPATH", "../src"}]}]).

fill([Nstr, Mstr]) ->
    {N, []} = string:to_integer(Nstr), 
    {M, []} = string:to_integer(Mstr),
    fill(N, M).

%% @doc fill N buckets with M msgs.
fill(N, M) ->
    Buckets = create_buckets(N),
    %% io:format("buckets created: ~p~n", [Buckets]), 
    lists:foreach( fun(K) ->
                            fill_bucket(Buckets, N, K)
                    end,
                    lists:seq(0,M-1)),
    lists:foreach( fun(B) ->
                            send_to_bucket(Buckets, B, stop)
                    end,
                    lists:seq(0, N-1)
                  ),
    Res = join(Buckets),
    io:format("fill(~p,~p)=~n~p~n",
              [N, M, Res]).

join(Buckets) ->
    Results = array:map( fun(_,B) ->
                                 receive_from_bucket(B)
                         end,
                         Buckets ),
    array:to_orddict(Results).


receive_from_bucket(Port) ->
    receive
        {Port, {data, Data}} ->
            port_close(Port),
            binary_to_term(Data)
    after
        500 ->
            {error, timeout}
    end.

