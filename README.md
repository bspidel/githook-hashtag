# githook-hashtag
manage hashtags in gitea database.

The following files are part of the application

- deploy - Read all ubn repository names from database then copy "update" to their respective server side hooks directory

- githook-hashtag.conf - server config values

- update - Upon a push to a ubn repository, remove all its hashtags and regenerate them by parsing all .md files.

