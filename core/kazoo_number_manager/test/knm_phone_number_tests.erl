%%%-----------------------------------------------------------------------------
%%% @copyright (C) 2016-2018, 2600Hz
%%% @doc
%%% @author Pierre Fenoll
%%% @end
%%%-----------------------------------------------------------------------------
-module(knm_phone_number_tests).

-include_lib("eunit/include/eunit.hrl").
-include("../src/knm.hrl").

is_dirty1_1_test_() ->
    {'ok', PN} = knm_phone_number:fetch(?TEST_OLD1_1_NUM),
    JObj = knm_phone_number:to_json(PN),
    FixtureJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_1.1.json"))),
    [?_assertEqual('false', knm_phone_number:is_dirty(PN))

    ,?_assertEqual(63648122255, kz_doc:created(FixtureJObj))
    ,?_assertEqual(kz_doc:created(FixtureJObj), kz_doc:created(JObj))
    ,?_assertEqual(kz_doc:created(FixtureJObj), knm_phone_number:created(PN))

    ,?_assertEqual(63648133355, kz_doc:modified(FixtureJObj))
    ,?_assertEqual(kz_doc:modified(FixtureJObj), kz_doc:modified(JObj))
    ,?_assertEqual(kz_doc:modified(FixtureJObj), knm_phone_number:modified(PN))
    ].

is_dirty1_test_() ->
    {'ok', PN} = knm_phone_number:fetch(?TEST_OLD1_NUM),
    JObj = knm_phone_number:to_json(PN),
    NewJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_1_out.json"))),
    OldJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_1_in.json"))),
    [?_assertEqual(kz_doc:id(NewJObj), kz_doc:id(JObj))
    ,?_assertEqual(kz_doc:id(OldJObj), kz_doc:id(JObj))
    ,?_assertEqual(kz_doc:id(OldJObj), knm_phone_number:number(PN))

    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(NewJObj)
                  ,kzd_phone_numbers:pvt_assigned_to(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(OldJObj)
                  ,kzd_phone_numbers:pvt_assigned_to(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(OldJObj)
                  ,knm_phone_number:assigned_to(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(NewJObj)
                  ,kzd_phone_numbers:pvt_db_name(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(OldJObj)
                  ,kzd_phone_numbers:pvt_db_name(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(OldJObj)
                  ,knm_phone_number:number_db(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_module_name(NewJObj)
                  ,kzd_phone_numbers:pvt_module_name(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_module_name(OldJObj)
                  ,kzd_phone_numbers:pvt_module_name(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_module_name(OldJObj)
                  ,knm_phone_number:module_name(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_ported_in(NewJObj)
                  ,kzd_phone_numbers:pvt_ported_in(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_ported_in(OldJObj)
                  ,kzd_phone_numbers:pvt_ported_in(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_ported_in(OldJObj)
                  ,knm_phone_number:ported_in(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_reserve_history(NewJObj)
                  ,kzd_phone_numbers:pvt_reserve_history(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_reserve_history(OldJObj)
                  ,kzd_phone_numbers:pvt_reserve_history(JObj)
                  )
    ,?_assertEqual([], knm_phone_number:reserve_history(PN))

    ,?_assertEqual(kzd_phone_numbers:pvt_state(NewJObj)
                  ,kzd_phone_numbers:pvt_state(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_state(OldJObj)
                  ,kzd_phone_numbers:pvt_state(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_state(OldJObj)
                  ,knm_phone_number:state(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_type(NewJObj)
                  ,kzd_phone_numbers:pvt_type(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_type(OldJObj)
                  ,kzd_phone_numbers:pvt_type(JObj)
                  )

    ,?_assertEqual('false', is_integer(kz_doc:created(OldJObj)))
    ,?_assert(is_integer(kz_doc:created(NewJObj)))
    ,?_assert(is_integer(kz_doc:created(JObj)))
    ,?_assert(is_integer(knm_phone_number:created(PN)))

    ,?_assert(knm_phone_number:is_dirty(PN))

    ,?_assertEqual('false', is_integer(kz_doc:modified(OldJObj)))
    ,?_assert(is_integer(kz_doc:modified(NewJObj)))
    ,?_assert(is_integer(kz_doc:modified(JObj)))
    ,?_assert(is_integer(knm_phone_number:modified(PN)))

    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_features(OldJObj))
    ,?_assertEqual(kz_json:from_list([{<<"local">>, kz_json:new()}])
                  ,kzd_phone_numbers:pvt_features(JObj)
                  )
    ,?_assertEqual(kz_json:from_list([{<<"local">>, kz_json:new()}])
                  ,kzd_phone_numbers:pvt_features(NewJObj)
                  )
    ,?_assertEqual(true
                  ,kz_json:are_equal(kzd_phone_numbers:pvt_features(NewJObj)
                                    ,knm_phone_number:features(PN)
                                    )
                  )

    ,?_assertEqual('undefined', kz_json:get_value(<<"used_by">>, OldJObj))
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_used_by(JObj))
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_used_by(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_used_by(NewJObj)
                  ,knm_phone_number:used_by(PN)
                  )

    ,?_assertNotEqual(?KNM_DEFAULT_AUTH_BY, kzd_phone_numbers:pvt_authorizing_account(OldJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_authorizing_account(NewJObj)
                  ,knm_phone_number:auth_by(PN)
                  )
    ].


is_dirty2_1_test_() ->
    {'ok', PN} = knm_phone_number:fetch(?TEST_OLD2_1_NUM),
    JObj = knm_phone_number:to_json(PN),
    FixtureJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_2.1.json"))),
    [?_assertEqual('false', knm_phone_number:is_dirty(PN))

    ,?_assertEqual(63637990853, kz_doc:modified(FixtureJObj))
    ,?_assertEqual(kz_doc:modified(FixtureJObj)
                  ,kz_doc:modified(JObj))
    ,?_assertEqual(kz_doc:modified(FixtureJObj)
                  ,knm_phone_number:modified(PN))

    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(FixtureJObj))
    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(JObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_state(FixtureJObj)
                  ,knm_phone_number:state(PN)
                  )
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_number_state(JObj))
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_number_state(FixtureJObj))

    ,?_assertEqual(<<"knm_pacwest">>, kzd_phone_numbers:pvt_module_name(FixtureJObj))
    ,?_assertEqual(<<"knm_pacwest">>, kzd_phone_numbers:pvt_module_name(JObj))
    ,?_assertEqual(<<"knm_pacwest">>, knm_phone_number:module_name(PN))
    ].

is_dirty2_2_test_() ->
    {'ok', PN} = knm_phone_number:fetch(?TEST_OLD2_2_NUM),
    JObj = knm_phone_number:to_json(PN),
    NewJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_2.2_out.json"))),
    OldJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_2.2_in.json"))),
    [?_assert(knm_phone_number:is_dirty(PN))

    ,?_assertEqual(<<"wnm_pacwest">>, kzd_phone_numbers:pvt_module_name(OldJObj))
    ,?_assertEqual(<<"knm_pacwest">>, kzd_phone_numbers:pvt_module_name(JObj))
    ,?_assertEqual(<<"knm_pacwest">>, kzd_phone_numbers:pvt_module_name(NewJObj))
    ,?_assertEqual(<<"knm_pacwest">>, knm_phone_number:module_name(PN))

    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(OldJObj))
    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(JObj))
    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_state(OldJObj)
                  ,knm_phone_number:state(PN)
                  )
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_number_state(JObj))
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_number_state(NewJObj))
    ].

is_dirty2_test_() ->
    {'ok', PN} = knm_phone_number:fetch(?TEST_OLD2_NUM),
    JObj = knm_phone_number:to_json(PN),
    NewJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_2_out.json"))),
    OldJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_2_in.json"))),

    [?_assertEqual(kz_doc:id(NewJObj)
                  ,kz_doc:id(JObj)
                  )
    ,?_assertEqual(kz_doc:id(OldJObj)
                  ,kz_doc:id(JObj)
                  )
    ,?_assertEqual(kz_doc:id(OldJObj)
                  ,knm_phone_number:number(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(NewJObj)
                  ,kzd_phone_numbers:pvt_assigned_to(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(OldJObj)
                  ,kzd_phone_numbers:pvt_assigned_to(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(OldJObj)
                  ,knm_phone_number:assigned_to(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(NewJObj)
                  ,kzd_phone_numbers:pvt_db_name(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(OldJObj)
                  ,kzd_phone_numbers:pvt_db_name(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(OldJObj)
                  ,knm_phone_number:number_db(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_reserve_history(NewJObj)
                  ,kzd_phone_numbers:pvt_reserve_history(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_reserve_history(OldJObj)
                  ,kzd_phone_numbers:pvt_reserve_history(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_reserve_history(OldJObj)
                  ,knm_phone_number:reserve_history(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_type(NewJObj)
                  ,kzd_phone_numbers:pvt_type(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_type(OldJObj)
                  ,kzd_phone_numbers:pvt_type(JObj)
                  )

    ,?_assertEqual(<<"knm_pacwest">>, kzd_phone_numbers:pvt_module_name(OldJObj))
    ,?_assertEqual(<<"knm_pacwest">>, kzd_phone_numbers:pvt_module_name(JObj))
    ,?_assertEqual(<<"knm_pacwest">>, kzd_phone_numbers:pvt_module_name(NewJObj))
    ,?_assertEqual(<<"knm_pacwest">>, knm_phone_number:module_name(PN))

    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_ported_in(OldJObj))
    ,?_assertEqual('false', kzd_phone_numbers:pvt_ported_in(JObj))
    ,?_assertEqual('false', kzd_phone_numbers:pvt_ported_in(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_ported_in(NewJObj)
                  ,knm_phone_number:ported_in(PN)
                  )

    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_number_state(OldJObj))
    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(JObj))
    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_number_state(OldJObj)
                  ,knm_phone_number:state(PN)
                  )
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_number_state(JObj))
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_number_state(NewJObj))

     %% pvt_number_state triggers the true here.
    ,?_assert(knm_phone_number:is_dirty(PN))

    ,?_assertEqual(63637990853, kz_doc:modified(OldJObj))
    ,?_assert(is_integer(kz_doc:modified(JObj)))
    ,?_assert(is_integer(kz_doc:modified(NewJObj)))
    ,?_assertEqual(kz_doc:modified(JObj)
                  ,knm_phone_number:modified(PN)
                  )

    ,?_assertEqual(63637990840, kz_doc:created(OldJObj))
    ,?_assertEqual(63637990840, kz_doc:created(JObj))
    ,?_assertEqual(63637990840, kz_doc:created(NewJObj))
    ,?_assertEqual(kz_doc:created(OldJObj)
                  ,knm_phone_number:created(PN)
                  )

    ,?_assertEqual([], kzd_phone_numbers:pvt_features(OldJObj))
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_features(JObj))
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_features(NewJObj))
    ,?_assertEqual(kz_json:new(), knm_phone_number:features(PN))

    ,?_assertEqual(<<>>, kz_json:get_value(<<"used_by">>, OldJObj))
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_used_by(JObj))
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_used_by(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_used_by(NewJObj)
                  ,knm_phone_number:used_by(PN)
                  )

    ,?_assertNotEqual(?KNM_DEFAULT_AUTH_BY, kzd_phone_numbers:pvt_authorizing_account(OldJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_authorizing_account(NewJObj)
                  ,knm_phone_number:auth_by(PN)
                  )
    ].


is_dirty3_1_test_() ->
    {'ok', PN} = knm_phone_number:fetch(?TEST_OLD3_1_NUM),
    JObj = knm_phone_number:to_json(PN),
    FixtureJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_3.1.json"))),
    [?_assertEqual('false', knm_phone_number:is_dirty(PN))

    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(FixtureJObj))
    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(JObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_state(FixtureJObj)
                  ,knm_phone_number:state(PN)
                  )
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_number_state(JObj))
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_number_state(FixtureJObj))

    ,?_assertEqual(<<"knm_bandwidth2">>, kzd_phone_numbers:pvt_module_name(FixtureJObj))
    ,?_assertEqual(<<"knm_bandwidth2">>, kzd_phone_numbers:pvt_module_name(JObj))
    ,?_assertEqual(<<"knm_bandwidth2">>, knm_phone_number:module_name(PN))
    ].

is_dirty3_test_() ->
    {'ok', PN} = knm_phone_number:fetch(?TEST_OLD3_NUM),
    JObj = knm_phone_number:to_json(PN),
    NewJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_3_out.json"))),
    OldJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_3_in.json"))),
    [?_assertEqual(kz_doc:id(NewJObj)
                  ,kz_doc:id(JObj)
                  )
    ,?_assertEqual(kz_doc:id(OldJObj)
                  ,kz_doc:id(JObj)
                  )
    ,?_assertEqual(kz_doc:id(OldJObj)
                  ,knm_phone_number:number(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(NewJObj)
                  ,kzd_phone_numbers:pvt_assigned_to(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(OldJObj)
                  ,kzd_phone_numbers:pvt_assigned_to(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(OldJObj)
                  ,knm_phone_number:assigned_to(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(NewJObj)
                  ,kzd_phone_numbers:pvt_db_name(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(OldJObj)
                  ,kzd_phone_numbers:pvt_db_name(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(OldJObj)
                  ,knm_phone_number:number_db(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_reserve_history(NewJObj)
                  ,kzd_phone_numbers:pvt_reserve_history(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_reserve_history(OldJObj)
                  ,kzd_phone_numbers:pvt_reserve_history(JObj)
                  )
    ,?_assertEqual([], knm_phone_number:reserve_history(PN))

    ,?_assertEqual(kzd_phone_numbers:pvt_type(NewJObj)
                  ,kzd_phone_numbers:pvt_type(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_type(OldJObj)
                  ,kzd_phone_numbers:pvt_type(JObj)
                  )

    ,?_assertEqual(<<"wnm_bandwidth">>, kzd_phone_numbers:pvt_module_name(OldJObj))
    ,?_assertEqual(<<"knm_bandwidth2">>, kzd_phone_numbers:pvt_module_name(JObj))
    ,?_assertEqual(<<"knm_bandwidth2">>, kzd_phone_numbers:pvt_module_name(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_module_name(NewJObj)
                  ,knm_phone_number:module_name(PN)
                  )

     %% pvt_module_name triggers the true here.
    ,?_assert(knm_phone_number:is_dirty(PN))

    ,?_assertEqual(63646110391, kz_doc:modified(OldJObj))
    ,?_assert(is_integer(kz_doc:modified(JObj)))
    ,?_assert(is_integer(kz_doc:modified(NewJObj)))
    ,?_assertEqual(kz_doc:modified(JObj)
                  ,knm_phone_number:modified(PN)
                  )

    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_ported_in(OldJObj))
    ,?_assertEqual('false', kzd_phone_numbers:pvt_ported_in(JObj))
    ,?_assertEqual('false', kzd_phone_numbers:pvt_ported_in(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_ported_in(NewJObj)
                  ,knm_phone_number:ported_in(PN)
                  )

    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(OldJObj))
    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(JObj))
    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_state(OldJObj)
                  ,knm_phone_number:state(PN)
                  )

    ,?_assertEqual(63646110391, kz_doc:created(OldJObj))
    ,?_assertEqual(63646110391, kz_doc:created(JObj))
    ,?_assertEqual(63646110391, kz_doc:created(NewJObj))
    ,?_assertEqual(kz_doc:created(OldJObj)
                  ,knm_phone_number:created(PN)
                  )

    ,?_assertEqual(kz_json:to_map(kzd_phone_numbers:pvt_features(OldJObj))
                  ,kz_json:to_map(kzd_phone_numbers:pvt_features(JObj)))
    ,?_assertEqual(kz_json:to_map(kzd_phone_numbers:pvt_features(OldJObj))
                  ,kz_json:to_map(kzd_phone_numbers:pvt_features(NewJObj)))
    ,?_assert(kz_json:are_equal(kzd_phone_numbers:pvt_features(OldJObj)
                               ,knm_phone_number:features(PN)
                               )
             )

    ,?_assertEqual(<<"callflow">>, kz_json:get_value(<<"used_by">>, OldJObj))
    ,?_assertEqual(<<"callflow">>, kzd_phone_numbers:pvt_used_by(JObj))
    ,?_assertEqual(<<"callflow">>, kzd_phone_numbers:pvt_used_by(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_used_by(NewJObj)
                  ,knm_phone_number:used_by(PN)
                  )
    ].


is_dirty4_1_test_() ->
    {'ok', PN} = knm_phone_number:fetch(?TEST_OLD4_1_NUM),
    JObj = knm_phone_number:to_json(PN),
    FixtureJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_4.1.json"))),
    [?_assertEqual('false', knm_phone_number:is_dirty(PN))

    ,?_assertEqual(kz_json:to_map(kzd_phone_numbers:pvt_features(FixtureJObj))
                  ,kz_json:to_map(kzd_phone_numbers:pvt_features(JObj)))
    ,?_assert(kz_json:are_equal(kzd_phone_numbers:pvt_features(FixtureJObj)
                               ,knm_phone_number:features(PN)
                               )
             )
    ].

is_dirty4_test_() ->
    {'ok', PN} = knm_phone_number:fetch(?TEST_OLD4_NUM),
    JObj = knm_phone_number:to_json(PN),
    NewJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_4_out.json"))),
    OldJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_4_in.json"))),
    [?_assertEqual(kz_doc:id(NewJObj)
                  ,kz_doc:id(JObj)
                  )
    ,?_assertEqual(kz_doc:id(OldJObj)
                  ,kz_doc:id(JObj)
                  )
    ,?_assertEqual(kz_doc:id(OldJObj)
                  ,knm_phone_number:number(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(NewJObj)
                  ,kzd_phone_numbers:pvt_assigned_to(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(OldJObj)
                  ,kzd_phone_numbers:pvt_assigned_to(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(OldJObj)
                  ,knm_phone_number:assigned_to(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(NewJObj)
                  ,kzd_phone_numbers:pvt_db_name(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(OldJObj)
                  ,kzd_phone_numbers:pvt_db_name(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(OldJObj)
                  ,knm_phone_number:number_db(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_reserve_history(NewJObj)
                  ,kzd_phone_numbers:pvt_reserve_history(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_reserve_history(OldJObj)
                  ,kzd_phone_numbers:pvt_reserve_history(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_reserve_history(OldJObj)
                  ,knm_phone_number:reserve_history(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_type(NewJObj)
                  ,kzd_phone_numbers:pvt_type(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_type(OldJObj)
                  ,kzd_phone_numbers:pvt_type(JObj)
                  )

    ,?_assertEqual(<<"wnm_local">>, kzd_phone_numbers:pvt_module_name(OldJObj))
    ,?_assertEqual(<<"knm_local">>, kzd_phone_numbers:pvt_module_name(JObj))
    ,?_assertEqual(<<"knm_local">>, kzd_phone_numbers:pvt_module_name(NewJObj))
    ,?_assertEqual(<<"knm_local">>, knm_phone_number:module_name(PN))

    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_ported_in(OldJObj))
    ,?_assertEqual('false', kzd_phone_numbers:pvt_ported_in(JObj))
    ,?_assertEqual('false', kzd_phone_numbers:pvt_ported_in(NewJObj))
    ,?_assertEqual('false', knm_phone_number:ported_in(PN))

    ,?_assertEqual(<<"reserved">>, kzd_phone_numbers:pvt_state(OldJObj))
    ,?_assertEqual(<<"reserved">>, kzd_phone_numbers:pvt_state(JObj))
    ,?_assertEqual(<<"reserved">>, kzd_phone_numbers:pvt_state(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_state(OldJObj)
                  ,knm_phone_number:state(PN)
                  )

    ,?_assertEqual(63627551737, kz_doc:created(OldJObj))
    ,?_assertEqual(63627551737, kz_doc:created(JObj))
    ,?_assertEqual(63627551737, kz_doc:created(NewJObj))
    ,?_assertEqual(63627551737, knm_phone_number:created(PN))

     %% Migrating doc and module_name makes this dirty
    ,?_assert(knm_phone_number:is_dirty(PN))

    ,?_assertEqual(63627551739, kz_doc:modified(OldJObj))
    ,?_assert(is_integer(kz_doc:modified(JObj)))
    ,?_assert(is_integer(kz_doc:modified(NewJObj)))
    ,?_assertEqual(kz_doc:modified(JObj)
                  ,knm_phone_number:modified(PN)
                  )

    ,?_assertEqual([], kzd_phone_numbers:pvt_features(OldJObj))
    ,?_assertEqual(#{<<"local">> => #{}}
                  ,kz_json:to_map(kzd_phone_numbers:pvt_features(JObj)))
    ,?_assertEqual(#{<<"local">> => #{}}
                  ,kz_json:to_map(kzd_phone_numbers:pvt_features(NewJObj)))
    ,?_assertEqual(true
                  ,kz_json:are_equal(kzd_phone_numbers:pvt_features(NewJObj)
                                    ,knm_phone_number:features(PN)
                                    )
                  )

    ,?_assertEqual(<<>>, kz_json:get_value(<<"used_by">>, OldJObj))
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_used_by(JObj))
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_used_by(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_used_by(NewJObj)
                  ,knm_phone_number:used_by(PN)
                  )

    ,?_assertEqual(kz_json:to_map(kz_doc:public_fields(JObj))
                  ,kz_json:to_map(kz_doc:public_fields(NewJObj)))
    ,?_assertEqual(maps:remove(<<"e911">>, kz_json:to_map(kz_doc:public_fields(JObj)))
                  ,kz_json:to_map(kz_doc:public_fields(kz_json:delete_key(<<"used_by">>, OldJObj))))
    ].


maps_take(Key, Map) ->
    {maps:get(Key, Map), maps:remove(Key, Map)}.

features_5(OldJObj) ->
    OldFeatures = kz_json:to_map(kzd_phone_numbers:pvt_features(OldJObj)),
    {E911, M} = maps_take(?LEGACY_DASH_E911, OldFeatures),
    M#{<<"e911">> => E911}.

public_fields_new_5(OldJObj) ->
    M = kz_json:to_map(
          kz_doc:public_fields(
            kz_json:delete_key(<<"used_by">>, OldJObj))),
    M#{<<"e911">> => maps:get(?LEGACY_DASH_E911, M)}.

is_dirty5_test_() ->
    {'ok', PN} = knm_phone_number:fetch(?TEST_OLD5_NUM),
    JObj = knm_phone_number:to_json(PN),
    NewJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_5_out.json"))),
    OldJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_5_in.json"))),
    [?_assertEqual(kz_doc:id(NewJObj)
                  ,kz_doc:id(JObj)
                  )
    ,?_assertEqual(kz_doc:id(OldJObj)
                  ,kz_doc:id(JObj)
                  )
    ,?_assertEqual(kz_doc:id(OldJObj)
                  ,knm_phone_number:number(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(NewJObj)
                  ,kzd_phone_numbers:pvt_assigned_to(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(OldJObj)
                  ,kzd_phone_numbers:pvt_assigned_to(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(OldJObj)
                  ,knm_phone_number:assigned_to(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(NewJObj)
                  ,kzd_phone_numbers:pvt_db_name(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(OldJObj)
                  ,kzd_phone_numbers:pvt_db_name(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(OldJObj)
                  ,knm_phone_number:number_db(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_reserve_history(NewJObj)
                  ,kzd_phone_numbers:pvt_reserve_history(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_reserve_history(OldJObj)
                  ,kzd_phone_numbers:pvt_reserve_history(JObj)
                  )
    ,?_assertEqual([], knm_phone_number:reserve_history(PN))

    ,?_assertEqual(kzd_phone_numbers:pvt_type(NewJObj)
                  ,kzd_phone_numbers:pvt_type(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_type(OldJObj)
                  ,kzd_phone_numbers:pvt_type(JObj)
                  )

    ,?_assertEqual(<<"knm_bandwidth2">>, kzd_phone_numbers:pvt_module_name(OldJObj))
    ,?_assertEqual(<<"knm_bandwidth2">>, kzd_phone_numbers:pvt_module_name(JObj))
    ,?_assertEqual(<<"knm_bandwidth2">>, kzd_phone_numbers:pvt_module_name(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_module_name(NewJObj)
                  ,knm_phone_number:module_name(PN)
                  )

    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_ported_in(OldJObj))
    ,?_assertEqual('false', kzd_phone_numbers:pvt_ported_in(JObj))
    ,?_assertEqual('false', kzd_phone_numbers:pvt_ported_in(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_ported_in(NewJObj)
                  ,knm_phone_number:ported_in(PN)
                  )

    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(OldJObj))
    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(JObj))
    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_state(OldJObj)
                  ,knm_phone_number:state(PN)
                  )

    ,?_assertEqual('undefined', kz_doc:created(OldJObj))
    ,?_assert(is_integer(kz_doc:created(JObj)))
    ,?_assert(is_integer(kz_doc:created(NewJObj)))
    ,?_assertEqual(kz_doc:created(JObj)
                  ,knm_phone_number:created(PN)
                  )

     %% Migrating doc, features & setting created, modified makes this dirty
    ,?_assert(knm_phone_number:is_dirty(PN))

    ,?_assertEqual('undefined', kz_doc:modified(OldJObj))
    ,?_assert(is_integer(kz_doc:modified(JObj)))
    ,?_assert(is_integer(kz_doc:modified(NewJObj)))
    ,?_assertEqual(kz_doc:modified(JObj)
                  ,knm_phone_number:modified(PN)
                  )

    ,?_assertEqual(features_5(OldJObj)
                  ,kz_json:to_map(kzd_phone_numbers:pvt_features(JObj)))
    ,?_assertEqual(features_5(OldJObj)
                  ,kz_json:to_map(kzd_phone_numbers:pvt_features(NewJObj)))
    ,?_assert(kz_json:are_equal(features_5(OldJObj), knm_phone_number:features(PN)))

    ,?_assertEqual(<<"trunkstore">>, kz_json:get_value(<<"used_by">>, OldJObj))
    ,?_assertEqual('undefined', kz_json:get_value(<<"used_by">>, JObj))
    ,?_assertEqual('undefined', kz_json:get_value(<<"used_by">>, NewJObj))
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_used_by(JObj))
    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_used_by(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_used_by(NewJObj)
                  ,knm_phone_number:used_by(PN)
                  )

    ,?_assertEqual(public_fields_new_5(OldJObj), kz_json:to_map(kz_doc:public_fields(JObj)))
    ,?_assertEqual(public_fields_new_5(OldJObj), kz_json:to_map(kz_doc:public_fields(NewJObj)))
    ].


is_dirty6_test_() ->
    {'ok', PN} = knm_phone_number:fetch(?TEST_OLD6_NUM),
    JObj = knm_phone_number:to_json(PN),
    NewJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_6_out.json"))),
    OldJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_6_in.json"))),
    [?_assertEqual(kz_doc:id(NewJObj)
                  ,kz_doc:id(JObj)
                  )
    ,?_assertEqual(kz_doc:id(OldJObj)
                  ,kz_doc:id(JObj)
                  )
    ,?_assertEqual(kz_doc:id(OldJObj)
                  ,knm_phone_number:number(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(NewJObj)
                  ,kzd_phone_numbers:pvt_assigned_to(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(OldJObj)
                  ,kzd_phone_numbers:pvt_assigned_to(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_assigned_to(OldJObj)
                  ,knm_phone_number:assigned_to(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(NewJObj)
                  ,kzd_phone_numbers:pvt_db_name(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(OldJObj)
                  ,kzd_phone_numbers:pvt_db_name(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_db_name(OldJObj)
                  ,knm_phone_number:number_db(PN)
                  )

    ,?_assertEqual(kzd_phone_numbers:pvt_reserve_history(NewJObj)
                  ,kzd_phone_numbers:pvt_reserve_history(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_reserve_history(OldJObj)
                  ,kzd_phone_numbers:pvt_reserve_history(JObj)
                  )
    ,?_assertEqual([], knm_phone_number:reserve_history(PN))

    ,?_assertEqual(kzd_phone_numbers:pvt_type(NewJObj)
                  ,kzd_phone_numbers:pvt_type(JObj)
                  )
    ,?_assertEqual(kzd_phone_numbers:pvt_type(OldJObj)
                  ,kzd_phone_numbers:pvt_type(JObj)
                  )

    ,?_assertEqual(<<"knm_local">>, kzd_phone_numbers:pvt_module_name(OldJObj))
    ,?_assertEqual(<<"knm_local">>, kzd_phone_numbers:pvt_module_name(JObj))
    ,?_assertEqual(<<"knm_local">>, kzd_phone_numbers:pvt_module_name(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_module_name(NewJObj)
                  ,knm_phone_number:module_name(PN)
                  )

    ,?_assertEqual('undefined', kzd_phone_numbers:pvt_ported_in(OldJObj))
    ,?_assertEqual('false', kzd_phone_numbers:pvt_ported_in(JObj))
    ,?_assertEqual('false', kzd_phone_numbers:pvt_ported_in(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_ported_in(NewJObj)
                  ,knm_phone_number:ported_in(PN)
                  )

    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(OldJObj))
    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(JObj))
    ,?_assertEqual(<<"in_service">>, kzd_phone_numbers:pvt_state(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_state(OldJObj)
                  ,knm_phone_number:state(PN)
                  )

    ,?_assertEqual(63640935218, kz_doc:created(OldJObj))
    ,?_assertEqual(kz_doc:created(OldJObj)
                  ,kz_doc:created(JObj))
    ,?_assertEqual(kz_doc:created(OldJObj)
                  ,kz_doc:created(NewJObj))
    ,?_assertEqual(kz_doc:created(OldJObj)
                  ,knm_phone_number:created(PN))

    ,?_assertEqual('false', knm_phone_number:is_dirty(PN))

    ,?_assertEqual(63640935218, kz_doc:modified(OldJObj))
    ,?_assertEqual(kz_doc:modified(OldJObj)
                  ,kz_doc:modified(JObj))
    ,?_assertEqual(kz_doc:modified(OldJObj)
                  ,kz_doc:modified(NewJObj))
    ,?_assertEqual(kz_doc:modified(OldJObj)
                  ,knm_phone_number:modified(PN))

    ,?_assertEqual(kz_json:to_map(kzd_phone_numbers:pvt_features(OldJObj))
                  ,kz_json:to_map(kzd_phone_numbers:pvt_features(JObj)))
    ,?_assertEqual(kz_json:to_map(kzd_phone_numbers:pvt_features(OldJObj))
                  ,kz_json:to_map(kzd_phone_numbers:pvt_features(NewJObj)))
    ,?_assert(kz_json:are_equal(kzd_phone_numbers:pvt_features(OldJObj)
                               ,knm_phone_number:features(PN)
                               )
             )

    ,?_assertEqual(<<"trunkstore">>, kz_json:get_value(<<"used_by">>, OldJObj))
    ,?_assertEqual(<<"trunkstore">>, kzd_phone_numbers:pvt_used_by(OldJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_used_by(OldJObj)
                  ,kzd_phone_numbers:pvt_used_by(JObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_used_by(OldJObj)
                  ,kzd_phone_numbers:pvt_used_by(NewJObj))
    ,?_assertEqual(kzd_phone_numbers:pvt_used_by(OldJObj)
                  ,knm_phone_number:used_by(PN))

    ,?_assertEqual(kz_json:to_map(kz_doc:public_fields(JObj))
                  ,kz_json:to_map(kz_doc:public_fields(NewJObj)))
    ,?_assertEqual(kz_json:to_map(kz_doc:public_fields(JObj))
                  ,kz_json:to_map(kz_doc:public_fields(kz_json:delete_key(<<"used_by">>, OldJObj))))
    ].


is_dirty7_1_test_() ->
    {'ok', PN} = knm_phone_number:fetch(?TEST_OLD7_1_NUM),
    JObj = knm_phone_number:to_json(PN),
    FixtureJObj = kz_json:decode(list_to_binary(knm_util:fixture("old_vsn_7.1.json"))),
    [?_assert(not knm_phone_number:is_dirty(PN))
    ,?_assert(kz_json:are_equal(FixtureJObj, JObj))
    ].


all_gets_should_not_be_dirty_test_() ->
    [[{"Verify reading test num "++binary_to_list(Num)++" is not dirty"
      ,?_assert(not knm_phone_number:is_dirty(PN))
      }
     ,{"Verify num "++binary_to_list(Num)++" is the id"
      ,?_assertEqual(Num, knm_phone_number:number(PN))
      }
     ]
     ++ verify_to_json(Num, PN)
     || Num <- nums(),
        PN <- [pn(Num)]
    ].

verify_to_json(Num, PN) ->
    JObj = knm_phone_number:to_json(PN),
    [?_assertEqual(Num, kz_doc:id(JObj))
    ,?_assert(kz_term:is_ne_binary(kzd_phone_numbers:pvt_db_name(JObj)))
    ,?_assert(knm_phone_number:is_state(kzd_phone_numbers:pvt_state(JObj)))
    ,?_assert(is_boolean(kzd_phone_numbers:pvt_ported_in(JObj)))
    ,?_assert(lists:member(kzd_phone_numbers:pvt_module_name(JObj)
                           %% For ?IN_SERVICE_BAD_CARRIER_NUMBER
                          ,[<<"knm_pacwest">> | knm_carriers:all_modules()]
                          ))
    ,?_assert(is_integer(kz_doc:modified(JObj)))
    ,?_assert(is_integer(kz_doc:created(JObj)))
    ,?_assertEqual(<<"number">>, kz_doc:type(JObj))
    ,?_assert(kz_term:is_ne_binary(kz_doc:revision(JObj)))
    ,?_assert(is_api_account_id(kzd_phone_numbers:pvt_assigned_to(JObj)))
    ,?_assert(is_api_account_id(kzd_phone_numbers:pvt_previously_assigned_to(JObj)))
    ,?_assert(lists:member(kzd_phone_numbers:pvt_used_by(JObj)
                          ,[undefined, <<"trunkstore">>, <<"callflow">>]
                          ))
    ,?_assert(is_valid_json(kzd_phone_numbers:pvt_features(JObj)))
    ,?_assert(is_undefined_or_ne_binaries(kzd_phone_numbers:pvt_features_allowed(JObj)))
    ,?_assert(is_undefined_or_ne_binaries(kzd_phone_numbers:pvt_features_denied(JObj)))
    ,?_assert(is_undefined_or_account_ids(kzd_phone_numbers:pvt_reserve_history(JObj)))
    ,?_assert(is_valid_json(kzd_phone_numbers:pvt_carrier_data(JObj)))
    ,?_assert(kz_term:is_api_ne_binary(kzd_phone_numbers:pvt_region(JObj)))
    ].

is_valid_json(undefined) -> true;
is_valid_json(V) -> kz_json:is_valid_json_object(V).

is_undefined_or_ne_binaries(undefined) -> true;
is_undefined_or_ne_binaries(V) -> kz_term:is_ne_binaries(V).

is_undefined_or_account_ids(undefined) -> true;
is_undefined_or_account_ids(V)
  when is_list(V) ->
    lists:all(fun is_account_id/1, V);
is_undefined_or_account_ids(_) -> false.

is_api_account_id(undefined) -> true;
is_api_account_id(V) -> is_account_id(V).

is_account_id(?MATCH_ACCOUNT_RAW(_)) -> true;
is_account_id(_) -> false.

pn(Num) ->
    {'ok', N} = knm_number:get(Num),
    knm_number:phone_number(N).

nums() ->
    [?TEST_AVAILABLE_NUM
    ,?TEST_IN_SERVICE_NUM
    ,?TEST_IN_SERVICE_MDN
    ,?TEST_IN_SERVICE_BAD_CARRIER_NUM
    ,?TEST_IN_SERVICE_WITH_HISTORY_NUM
    ,?TEST_RESERVED_NUM
    ,?TEST_EXISTING_TOLL
    ,?TEST_OLD1_1_NUM
    ,?TEST_OLD2_1_NUM
    ,?TEST_OLD3_1_NUM
    ,?TEST_OLD4_1_NUM
    ,?TEST_OLD5_1_NUM
    ,?TEST_OLD6_NUM
    ,?TEST_OLD7_NUM
    ,?TEST_OLD7_1_NUM
    ,?TEST_TELNYX_NUM
    ,?TEST_VITELITY_NUM
    ,?TEST_PORT_IN_NUM
    ,?TEST_PORT_IN2_NUM
    ,?TEST_PORT_IN3_NUM
    ,?BW_EXISTING_DID
    ,?TEST_AVAILABLE_NON_LOCAL_NUM
    ].
