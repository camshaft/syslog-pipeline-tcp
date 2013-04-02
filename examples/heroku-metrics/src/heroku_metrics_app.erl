%% @private
-module(heroku_metrics_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

start(_Type, _Args) ->
  {ok, _} = syslog_drain:start_server(syslog, 100, [{port, 10514}], [
    {parsers, [syslog_message_keyvalue]},
    {emitters, []}
  ]),
  heroku_metrics_sup:start_link().

stop(_State) ->
  ok.
