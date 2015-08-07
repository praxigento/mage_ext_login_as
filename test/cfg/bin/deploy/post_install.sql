--
--      Change instance specific config.
--
REPLACE INTO ${CFG_DB_PREFIX}core_config_data SET value = '1', path ='dev/template/allow_symlink';
REPLACE INTO ${CFG_DB_PREFIX}core_config_data SET value = '1', path ='dev/log/active';
-- Module activation
REPLACE INTO ${CFG_DB_PREFIX}core_config_data SET value = '1', path ='prxgt_lgas/general/enabled';
REPLACE INTO ${CFG_DB_PREFIX}core_config_data SET value = '1', path ='prxgt_lgas/general/log_events';
REPLACE INTO ${CFG_DB_PREFIX}core_config_data SET value = '1', path ='prxgt_lgas/ui/action_enabled';
REPLACE INTO ${CFG_DB_PREFIX}core_config_data SET value = '1', path ='prxgt_lgas/ui/orders_grid_column_enabled';
REPLACE INTO ${CFG_DB_PREFIX}core_config_data SET value = '1', path ='prxgt_lgas/ui/orders_grid_column_position';