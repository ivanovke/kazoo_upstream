%%%-----------------------------------------------------------------------------
%%% @copyright (C) 2010-2019, 2600Hz
%%% @doc Accessors for `functions' document.
%%% @end
%%%-----------------------------------------------------------------------------
-module(kzd_functions).

-export([new/0]).
-export([enabled/1, enabled/2, set_enabled/2]).
-export([function_js/1, function_js/2, set_function_js/2]).
-export([name/1, name/2, set_name/2]).
-export([trigger/1, trigger/2, set_trigger/2]).


-include("kz_documents.hrl").

-type doc() :: kz_json:object().
-export_type([doc/0]).

-define(SCHEMA, <<"functions">>).

-spec new() -> doc().
new() ->
    kz_json_schema:default_object(?SCHEMA).

-spec enabled(doc()) -> boolean().
enabled(Doc) ->
    enabled(Doc, true).

-spec enabled(doc(), Default) -> boolean() | Default.
enabled(Doc, Default) ->
    kz_json:get_boolean_value([<<"enabled">>], Doc, Default).

-spec set_enabled(doc(), boolean()) -> doc().
set_enabled(Doc, Enabled) ->
    kz_json:set_value([<<"enabled">>], Enabled, Doc).

-spec function_js(doc()) -> kz_term:api_binary().
function_js(Doc) ->
    function_js(Doc, 'undefined').

-spec function_js(doc(), Default) -> binary() | Default.
function_js(Doc, Default) ->
    kz_json:get_binary_value([<<"function_js">>], Doc, Default).

-spec set_function_js(doc(), binary()) -> doc().
set_function_js(Doc, FunctionJs) ->
    kz_json:set_value([<<"function_js">>], FunctionJs, Doc).

-spec name(doc()) -> kz_term:api_binary().
name(Doc) ->
    name(Doc, 'undefined').

-spec name(doc(), Default) -> binary() | Default.
name(Doc, Default) ->
    kz_json:get_binary_value([<<"name">>], Doc, Default).

-spec set_name(doc(), binary()) -> doc().
set_name(Doc, Name) ->
    kz_json:set_value([<<"name">>], Name, Doc).

-spec trigger(doc()) -> kz_term:api_binary().
trigger(Doc) ->
    trigger(Doc, 'undefined').

-spec trigger(doc(), Default) -> binary() | Default.
trigger(Doc, Default) ->
    kz_json:get_binary_value([<<"trigger">>], Doc, Default).

-spec set_trigger(doc(), binary()) -> doc().
set_trigger(Doc, Trigger) ->
    kz_json:set_value([<<"trigger">>], Trigger, Doc).
