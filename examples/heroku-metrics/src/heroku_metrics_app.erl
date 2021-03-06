%% @private
-module(heroku_metrics_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

start(_Type, _Args) ->
  syslog_pipeline_riemann_emitter:start("127.0.0.1", 5555),

  {ok, _} = syslog_pipeline_tcp:start_server(syslog, 100, [{port, 10514}], [
    {body_parser, syslog_message_keyvalue},
    {emitters, [
      {heroku_metrics_stdout_emitter, [
        heroku_metrics_route_expander,
        dyno_metric_expander
      ]}
    ]}
  ]),

  heroku_metrics_sup:start_link().

stop(_State) ->
  ok.
