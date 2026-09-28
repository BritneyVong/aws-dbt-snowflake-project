# Airbnb Data Pipeline (dbt + Snowflake)

A hands-on data engineering project that takes raw Airbnb data (bookings, listings, and hosts) and turns it into clean, query-ready tables in Snowflake, using dbt to manage every transformation step.

## What it does

Raw CSV-style data gets loaded into Snowflake, then progressively cleaned and reshaped across three stages:

- **Bronze** – the data as it arrives, barely touched
- **Silver** – cleaned up, standardized, deduplicated
- **Gold** – the finished product: a wide combined table (`obt`) and a proper `fact` table ready for reporting, plus snapshot tables that track how listings and hosts change over time

## Built with

- Snowflake (data warehouse)
- dbt (SQL transformations, models, snapshots)
- Python + `uv` (project/dependency management)
- Git/GitHub

## Notable problems I ran into and fixed

- A snapshot table that quietly ballooned to over 500,000 rows because it kept treating every re-run as a "new change" — traced it back to a wrong source table and a mismatched column name, then rebuilt it properly with deduplication logic
- A join that technically ran without errors but silently multiplied into billions of rows, which took some real digging through Snowflake's query profiler to catch
- Several small but stubborn syntax issues in dbt's Jinja templating (wrong brackets, missing parentheses, a stray semicolon) that don't show up until you actually try to compile the model
- Getting dbt to authenticate against Snowflake at all — first tried SSO, hit a wall, ended up setting a dedicated password via SQL instead
- Untangling a Python project structure (via `uv`) after some early setup mistakes, including workspace/package naming collisions
