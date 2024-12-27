We use neo4j for some scraping stuff, unfortunately it's a behemoth of a system and the documentation is a bit of a mess.
This is especially true in testing and with neo4jrb migrations. Anyways, we're not actually using that code, so if there's a problem do this:

- `rm -r /opt/homebrew/var/neo4j/data/`
- `neo4j-admin dbms set-initial-password <password>`
- `rake neo4j:migrate`
