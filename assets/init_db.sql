
-- User-specific database

CREATE TABLE IF NOT EXISTS user_info (
  id TEXT PRIMARY KEY,
  uid INTEGER NOT NULL,
  info TEXT NOT NULL, -- raw json from server.
  properties TEXT NOT NULL,
  avatar BLOB NOT NULL, 
  created_at INTEGER NOT NULL);

CREATE UNIQUE INDEX IF NOT EXISTS index_uid ON user_info(uid);

CREATE TABLE IF NOT EXISTS group_info (
  id TEXT PRIMARY KEY,
  gid integer NOT NULL,
  last_local_mid TEXT NOT NULL,
  info TEXT NOT NULL, -- raw json from server.
  avatar BLOB NOT NULL,
  properties TEXT NOT NULL,
  is_public integer NOT NULL,
  is_active integer NOT NULL,
  created_at integer NOT NULL,
  updated_at integer NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS index_gid ON group_info(gid);

CREATE TABLE IF NOT EXISTS dm_info (
  id TEXT PRIMARY KEY,
  dm_uid INTEGER NOT NULL,
  last_local_mid TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS index_dm_uid ON dm_info(dm_uid);

CREATE TABLE IF NOT EXISTS chat_msg (
  id TEXT PRIMARY KEY,
  mid INTEGER NOT NULL,
  local_mid TEXT NOT NULL,
  from_uid INTEGER NOT NULL,
  dm_uid INTEGER NOT NULL,
  gid INTEGER NOT NULL,
  edited INTEGER NOT NULL,
  status TEXT NOT NULL,
  detail TEXT NOT NULL,
  reactions TEXT NOT NULL,
  pin integer NOT NULL,
  created_at integer NOT NULL
);
CREATE INDEX IF NOT EXISTS index_mid ON chat_msg(mid);
CREATE UNIQUE INDEX IF NOT EXISTS index_local_mid ON chat_msg(local_mid);
CREATE INDEX IF NOT EXISTS index_from_uid ON chat_msg(from_uid);
CREATE INDEX IF NOT EXISTS index_dm_uid ON chat_msg(dm_uid);
CREATE INDEX IF NOT EXISTS index_gid ON chat_msg(gid);


CREATE TABLE IF NOT EXISTS open_graphic_thumb (
  id TEXT NOT NULL,
  file_id TEXT NOT NULL,
  thumbnail BLOB NOT NULL,
  site_name TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  url TEXT NOT NULL,
  created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS file (
  id TEXT PRIMARY KEY,
  file_id TEXT NOT NULL,
  file BLOB NOT NULL,
  created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS archive (
  id TEXT PRIMARY KEY,
  archive TEXT NOT NULL,
  created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS archive_file (
  id TEXT PRIMARY KEY,
  file_path TEXT NOT NULL,
  file_id INTEGER NOT NULL,
  file BLOB NOT NULL,
  created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS saved (
  id TEXT PRIMARY KEY,
  properties TEXT NOT NULL,
  saved TEXT NOT NULL,
  created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS saved_file (
  id TEXT PRIMARY KEY,
  file_path TEXT NOT NULL,
  file_id INTEGER NOT NULL,
  file BLOB NOT NULL,
  created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS unmatched_reaction (
  id TEXT PRIMARY KEY,
  target_mid INTEGER NOT NULL,
  reaction_list TEXT NOT NULL,
  created_at INTEGER NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS index_target_mid ON unmatched_reaction(target_mid);

