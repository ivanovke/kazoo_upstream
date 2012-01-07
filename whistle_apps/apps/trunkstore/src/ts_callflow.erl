%%%-------------------------------------------------------------------
%%% @author James Aimonetti <james@2600hz.org>
%%% @copyright (C) 2011, James Aimonetti
%%% @doc
%%% Common functionality for onnet and offnet call handling
%%% @end
%%% Created : 30 Jun 2011 by James Aimonetti <james@2600hz.org>
%%%-------------------------------------------------------------------
-module(ts_callflow).

-export([init/1, start_amqp/1, send_park/1, wait_for_win/1
	 ,wait_for_bridge/1, wait_for_cdr/1, send_hangup/1
	 ,finish_leg/2
	]).

%% data access functions
-export([get_request_data/1, get_my_queue/1, get_control_queue/1, set_endpoint_data/2
	 ,set_account_id/2, get_aleg_id/1, get_bleg_id/1, get_call_cost/1
	 ,set_failover/2, get_failover/1, get_endpoint_data/1, get_account_id/1
	]).

-include("ts.hrl").

-define(WAIT_FOR_WIN_TIMEOUT, 5000). %% 5 seconds
-define(WAIT_FOR_BRIDGE_TIMEOUT, 30000). %% 30 secs
-define(WAIT_FOR_HANGUP_TIMEOUT, 1000 * 60 * 60 * 1). %% 1 hour
-define(WAIT_FOR_CDR_TIMEOUT, 5000).

-record(state, {
	  aleg_callid = <<>> :: binary()
	  ,bleg_callid = <<>> :: binary()
          ,acctid = <<>> :: binary()
	  ,route_req_jobj = wh_json:new() :: json_object()
          ,ep_data = wh_json:new() :: json_object() %% data for the endpoint, either an actual endpoint or an offnet request
          ,my_q = <<>> :: binary()
          ,callctl_q = <<>> :: binary()
	  ,call_cost = 0.0 :: float()
          ,failover = wh_json:new() :: json_object()
	 }).

-spec init/1 :: (json_object()) -> #state{}.
init(RouteReqJObj) ->
    CallID = wh_json:get_value(<<"Call-ID">>, RouteReqJObj),
    put(callid, CallID),
    ?LOG("Init done"),
    #state{aleg_callid=CallID, route_req_jobj=RouteReqJObj, acctid=wh_json:get_value([<<"Custom-Channel-Vars">>, <<"Account-ID">>], RouteReqJObj)}.

-spec start_amqp/1 :: (#state{}) -> #state{}.
start_amqp(#state{}=State) ->
    Q = amqp_util:new_queue(),

    %% Bind the queue to an exchange
    _ = amqp_util:bind_q_to_targeted(Q),
    _ = amqp_util:basic_consume(Q, [{exclusive, false}]),

    ?LOG("Started AMQP with queue ~s", [Q]),
    State#state{my_q=Q}.

-spec send_park/1 :: (#state{}) -> #state{}.
send_park(#state{aleg_callid=CallID, my_q=Q, route_req_jobj=JObj}=State) ->
    Resp = [{<<"Msg-ID">>, wh_json:get_value(<<"Msg-ID">>, JObj)}
            ,{<<"Routes">>, []}
            ,{<<"Method">>, <<"park">>}
            | wh_api:default_headers(Q, ?APP_NAME, ?APP_VERSION)],
    ?LOG("sending park route response"),
    wapi_route:publish_resp(wh_json:get_value(<<"Server-ID">>, JObj), Resp),

    _ = amqp_util:bind_q_to_callevt(Q, CallID),
    _ = amqp_util:bind_q_to_callevt(Q, CallID, cdr),
    _ = amqp_util:basic_consume(Q, [{exclusive, false}]), %% need to verify if this step is needed
    State.

-spec wait_for_win/1 :: (#state{}) -> {'won' | 'lost', #state{}}.
wait_for_win(#state{aleg_callid=CallID}=State) ->
    receive
	#'basic.consume_ok'{} -> wait_for_win(State);

	%% call events come from callevt exchange, ignore for now
	{#'basic.deliver'{exchange = <<"targeted">>}, #amqp_msg{payload=Payload}} ->
	    WinJObj = mochijson2:decode(Payload),
	    true = wapi_route:win_v(WinJObj),
	    CallID = wh_json:get_value(<<"Call-ID">>, WinJObj),

	    CallctlQ = wh_json:get_value(<<"Control-Queue">>, WinJObj),

	    {won, State#state{callctl_q=CallctlQ}}
    after ?WAIT_FOR_WIN_TIMEOUT ->
	    ?LOG("Timed out(~b) waiting for route_win", [?WAIT_FOR_WIN_TIMEOUT]),
	    {lost, State}
    end.

-spec wait_for_bridge/1 :: (#state{}) -> {'bridged' | 'error' | 'hangup' | 'timeout', #state{}}.
-spec wait_for_bridge/2 :: (#state{}, integer()) -> {'bridged' | 'error' | 'hangup' | 'timeout', #state{}}.
wait_for_bridge(State) ->
    wait_for_bridge(State, ?WAIT_FOR_BRIDGE_TIMEOUT).
wait_for_bridge(State, Timeout) ->
    Start = erlang:now(),
    receive
	{_, #amqp_msg{payload=Payload}} ->
	    JObj = mochijson2:decode(Payload),
	    case process_event_for_bridge(State, JObj) of
		ignore ->
		    wait_for_bridge(State, Timeout - (timer:now_diff(erlang:now(), Start) div 1000));
		{bridged, _}=Success -> Success;
		{error, _}=Error -> Error;
		{hangup, _}=Hangup -> Hangup
	    end;
	_E ->
	    ?LOG("Unexpected msg: ~p", [_E]),
	    wait_for_bridge(State, Timeout - (timer:now_diff(erlang:now(), Start) div 1000))
    after Timeout ->
	    ?LOG("Timeout waiting for bridge"),
	    {timeout, State}
    end.

-spec process_event_for_bridge/2 :: (#state{}, json_object()) -> 'ignore' | {'bridged' | 'error' | 'hangup', #state{}}.
process_event_for_bridge(#state{aleg_callid=ALeg, my_q=Q, callctl_q=CtlQ}=State, JObj) ->
    case { wh_json:get_value(<<"Application-Name">>, JObj)
	   ,wh_json:get_value(<<"Event-Name">>, JObj)
	   ,wh_json:get_value(<<"Event-Category">>, JObj) } of

	{_, <<"offnet_resp">>, <<"resource">>} ->
	    case wh_json:get_value(<<"Response-Message">>, JObj) of
		<<"ERROR">> ->
		    Failure = wh_json:get_value(<<"Error-Message">>, JObj, wh_json:get_value(<<"Response-Code">>, JObj)),
		    ?LOG("offnet failed: ~s", [Failure]),
		    {error, State};
		<<"SUCCESS">> ->
		    ?LOG("offnet bridge has completed"),
		    ?LOG("~p", [JObj]),
		    {hangup, State}
	    end;

	{ _, <<"CHANNEL_BRIDGE">>, <<"call_event">> } ->
	    BLeg = wh_json:get_value(<<"Other-Leg-Unique-ID">>, JObj),
	    ?LOG("Bridged to ~s successful", [BLeg]),
	    ?LOG(BLeg, "Bridged from ~s successful", [ALeg]),

	    _ = amqp_util:bind_q_to_callevt(Q, BLeg, cdr),
	    _ = amqp_util:basic_consume(Q),
	    {bridged, State#state{bleg_callid=BLeg}};

	{ _, <<"CHANNEL_HANGUP">>, <<"call_event">> } ->
	    ?LOG("Channel hungup before bridge"),
	    {hangup, State};

	{ _, _, <<"error">> } ->
	    ?LOG("Execution failed"),
	    {error, State};

	{ _, <<"resource_error">>, <<"resource">> } ->
	    Code = wh_json:get_value(<<"Failure-Code">>, JObj, <<"486">>),
	    Message = wh_json:get_value(<<"Failure-Message">>, JObj),

	    ?LOG("Failed to bridge to offnet"),
	    ?LOG("Failure message: ~s", [Message]),
	    ?LOG("Failure code: ~s", [Code]),

	    %% send failure code to Call
	    wh_util:call_response(ALeg, CtlQ, Code, Message),

	    {hangup, State};
	_Unhandled ->
	    ?LOG("Unhandled combo: ~p", [_Unhandled]),
	    ignore
    end.

-spec wait_for_cdr/1 :: (#state{}) -> {'timeout', #state{}} | {'cdr', 'aleg' | 'bleg', json_object(), #state{}}.
-spec wait_for_cdr/2 :: (#state{}, pos_integer() | 'infinity') -> {'timeout', #state{}} | {'cdr', 'aleg' | 'bleg', json_object(), #state{}}.
wait_for_cdr(State) ->
    wait_for_cdr(State, infinity).
wait_for_cdr(State, Timeout) ->
    receive
	{_, #amqp_msg{payload=Payload}} ->
	    JObj = mochijson2:decode(Payload),
	    case process_event_for_cdr(State, JObj) of
		{cdr, _, _, _}=CDR -> CDR;
		{hangup, State1} ->
                    send_hangup(State1),
                    wait_for_cdr(State1, ?WAIT_FOR_CDR_TIMEOUT);
		ignore -> wait_for_cdr(State, Timeout)
	    end
    after Timeout ->
	    {timeout, State}
    end.

-spec process_event_for_cdr/2 :: (#state{}, json_object()) -> {'hangup', #state{}} | 'ignore' |
							      {'cdr', 'aleg' | 'bleg', json_object(), #state{}}.
process_event_for_cdr(#state{aleg_callid=ALeg, acctid=AcctID}=State, JObj) ->
    case wh_util:get_event_type(JObj) of
	{<<"resource">>, <<"offnet_resp">>} ->
	    case wh_json:get_value(<<"Response-Message">>) of
		<<"SUCCESS">> ->
		    ?LOG("bridge was successful, still waiting on the CDR"),
		    ignore;
		<<"ERROR">> ->
		    Failure = wh_json:get_value(<<"Error-Message">>, JObj, wh_json:get_value(<<"Response-Code">>, JObj)),
		    ?LOG("offnet failed: ~s but waiting for the CDR still", [Failure]),
		    ignore
	    end;

	{ <<"call_event">>, <<"CHANNEL_HANGUP">> } ->
	    ?LOG("Hangup received, waiting on CDR"),
	    {hangup, State};

        { <<"call_event">>, <<"CHANNEL_UNBRIDGE">> } ->
            ?LOG("Unbridge received, waiting on CDR"),
            {hangup, State};

	{ <<"error">>, _ } ->
	    ?LOG("Error received, waiting on CDR"),
	    {hangup, State};

	{ <<"call_event">>, <<"CHANNEL_EXECUTE_COMPLETE">>} ->
	    case {wh_json:get_value(<<"Application-Name">>, JObj), wh_json:get_value(<<"Application-Response">>, JObj)} of
		{<<"bridge">>, <<"SUCCESS">>} ->
		    ?LOG("Bridge event finished successfully, sending hangup"),
                    send_hangup(State),
                    ignore;
		{<<"bridge">>, Cause} ->
		    ?LOG("Failed to bridge: ~s", [Cause]),
		    {error, State};
                {_,_} ->
                    ignore
	    end;

	{ <<"call_detail">>, <<"cdr">> } ->
	    true = wapi_call:cdr_v(JObj),
	    Leg = wh_json:get_value(<<"Call-ID">>, JObj),
	    Duration = ts_util:get_call_duration(JObj),

	    {R, RI, RM, S} = ts_util:get_rate_factors(JObj),
	    Cost = ts_util:calculate_cost(R, RI, RM, S, Duration),

	    ?LOG("CDR received for leg ~s", [Leg]),
	    ?LOG("Leg to be billed for ~b seconds", [Duration]),
	    ?LOG("Acct ~s to be charged ~p if per_min", [AcctID, Cost]),

	    case Leg =:= ALeg of
		true -> {cdr, aleg, JObj, State#state{call_cost=Cost}};
		false -> {cdr, bleg, JObj, State#state{call_cost=Cost}}
	    end;
	_E ->
	    ?LOG("Ignorable event: ~p", [_E]),
	    ignore
    end.

-spec finish_leg/2 :: (#state{}, 'undefined' | ne_binary()) -> 'ok'.
finish_leg(_State, undefined) ->
    ok;
finish_leg(#state{acctid=AcctID, call_cost=Cost}=State, Leg) ->
    ok = ts_acctmgr:release_trunk(AcctID, Leg, Cost),
    send_hangup(State).

-spec send_hangup/1 :: (#state{}) -> 'ok'.
send_hangup(#state{callctl_q = <<>>}) ->
    ok;
send_hangup(#state{callctl_q=CtlQ, my_q=Q, aleg_callid=CallID}) ->
    Command = [
	       {<<"Application-Name">>, <<"hangup">>}
	       ,{<<"Call-ID">>, CallID}
               ,{<<"Insert-At">>, <<"now">>}
	       | wh_api:default_headers(Q, <<"call">>, <<"command">>, ?APP_NAME, ?APP_VERSION)
	      ],
    {ok, JSON} = wapi_dialplan:hangup(Command),
    ?LOG("Sending hangup to ~s: ~s", [CtlQ, JSON]),
    wapi_dialplan:publish_action(CtlQ, JSON, <<"application/json">>).

%%%-----------------------------------------------------------------------------
%%% Data access functions
%%%-----------------------------------------------------------------------------
-spec get_request_data/1 :: (#state{}) -> json_object().
get_request_data(#state{route_req_jobj=JObj}) ->
    JObj.

-spec set_endpoint_data/2 :: (#state{}, json_object()) -> #state{}.
set_endpoint_data(State, Data) ->
    State#state{ep_data=Data}.

-spec get_endpoint_data/1 :: (#state{}) -> json_object().
get_endpoint_data(#state{ep_data=EP}) ->
    EP.

-spec set_account_id/2 :: (#state{}, ne_binary()) -> #state{}.
set_account_id(State, ID) ->
    State#state{acctid=ID}.

-spec get_account_id/1 :: (#state{}) -> ne_binary().
get_account_id(#state{acctid=ID}) ->
    ID.

-spec get_my_queue/1 :: (#state{}) -> ne_binary().
-spec get_control_queue/1 :: (#state{}) -> ne_binary().
get_my_queue(#state{my_q=Q}) ->
    Q.
get_control_queue(#state{callctl_q=CtlQ}) ->
    CtlQ.

-spec get_aleg_id/1 :: (#state{}) -> ne_binary().
-spec get_bleg_id/1 :: (#state{}) -> ne_binary().
get_aleg_id(#state{aleg_callid=ALeg}) ->
    ALeg.
get_bleg_id(#state{bleg_callid=ALeg}) ->
    ALeg.

-spec get_call_cost/1 :: (#state{}) -> float().
get_call_cost(#state{call_cost=Cost}) ->
    Cost.

-spec set_failover/2 :: (#state{}, json_object()) -> #state{}.
set_failover(State, Failover) ->
    State#state{failover=Failover}.

-spec get_failover/1 :: (#state{}) -> json_object().
get_failover(#state{failover=Fail}) ->
    Fail.
