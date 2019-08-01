%%%-----------------------------------------------------------------------------
%%% @copyright (C) 2010-2019, 2600Hz
%%% @doc
%%% @end
%%%-----------------------------------------------------------------------------
-module(kz_fixturedb_maintenance).

-export([dummy_plan/0
        ,new_connection/0, new_connection/1
        ]).

-include("kz_fixturedb.hrl").

%%------------------------------------------------------------------------------
%% @doc
%% @end
%%------------------------------------------------------------------------------
-spec dummy_plan() -> map().
dummy_plan() ->
    #{server => {kazoo_fixturedb, new_connection()}}.

-spec new_connection() -> server_map().
new_connection() -> new_connection(#{}).

-spec new_connection(map()) -> server_map().
new_connection(Map) ->
    {'ok', Server} = kz_fixturedb_server:new_connection(Map),
    Server.
