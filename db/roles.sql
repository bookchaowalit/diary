-- Roles for the diary database. Locally a superuser runs this; on Neon
-- `diary-db provision` creates the same roles through the migrator.
--
-- diary_migrator  owns the schema and runs migrations only.
-- diary_api       the API at runtime: no superuser, no BYPASSRLS, owns nothing.
-- diary_publisher sweeps and marks the outbox across workspaces; nothing else.

DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'diary_migrator') THEN
        CREATE ROLE diary_migrator LOGIN NOSUPERUSER NOCREATEROLE NOBYPASSRLS;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'diary_api') THEN
        CREATE ROLE diary_api LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS NOINHERIT;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'diary_publisher') THEN
        CREATE ROLE diary_publisher LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOBYPASSRLS NOINHERIT;
    END IF;
END
$$;
