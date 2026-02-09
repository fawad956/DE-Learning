--Day 3 - 1 dimensional data modeling in postgresql

CREATE TYPE vertex_type
AS ENUM('player', 'team','game');

create table vertices(
	identifier TEXT,
	type vertex_type,
	properties JSON,
	PRIMARY KEY(identifier, type)
)
CREATE TYPE edge_type AS
	ENUM('plays-against', 
		 'shares_team',
		 'plays_in',
		 'plays_on'
		 )

CREATE TABLE edges (
		edge_id TEXT,
		subject_identifier TEXT,
		subject_type vertex_type,
		object_identifier TEXT,
		object_type vertex_type,
		edge_type edge_type,
		properties JSON,	
		PRIMARY KEY(subject_identifier,
					subject_type,
					object_identifier,
					object_type,
					edge_type)
)

INSERT INTO vertices
SELECT 
	game_id AS identifier,
	'game'::vertex_type AS type,
	json_build_object(
		'pts_home', pts_home,
		'pts_away', pts_away,
		'winning_team', CASE when home_team_wins = 1 THEN home_team_id ELSE visitor_team_id END
) AS properties
FROM GAMES


INSERT INTO vertices
WITH players_agg AS (
SELECT
	player_id AS identifier,
	MAX(player_name) AS player_name,
	COUNT(1) as number_of_games,
	SUM(pts) as total_points,
	ARRAY_AGG(DISTINCT team_id) AS teams
FROM game_details
GROUP BY player_id
)
SELECT identifier, 'player'::vertex_type,
	json_build_object(
		'player_name', player_name, 
		'number_of_games', number_of_games,
		'total_points', total_points,
		'teams', teams)
FROM players_agg


INSERT INTO vertices
WITH teams_deduped AS ( --to handle dups
	SELECT *, ROW_NUMBER() OVER(PARTITION BY team_id) as row_num
	FROM teams	
)
SELECT 
	team_id AS identifier,
	'team'::vertex_type AS type,
	json_build_object(
		'abbreviation', abbreviation,
		'nickname', nickname,
		'city', city,
		'arena', arena,
		'year_founded', yearfounded
	)
	FROM teams_deduped
WHERE row_num = 1

SELECT  
	v.properties->>'player_name',
	MAX(e.properties->>'pts')
	from vertices v 
	JOIN edges e
	ON e.subject_identifier = v.identifier
	AND e.subject_type = v.type
GROUP BY 1

INSERT INTO edges
WITH deduped AS (

	SELECT *, row_number() over (PARTITION BY player_id, gmae_id) AS row_number
	FROM game_details
),
	filtered AS (
		SELECT * FROM deduped
		where row_num=1
	)
	select 
		f1.player_name,
		f2.player_name,
		f1.team_abbreviation,
		f2.team_abbreviation,
		from filtered f1
		JOIN filtered f2
		ON f1.game_id = f2.game_id
		AND f1.player_name <> f2.player_name


SELECT 
	player_id AS subject_identifier,
	'player'::vertex_type as subject_type,
	game_id AS object_identifier,
	'game'::vertex_type AS object_type,
	'plays_in'::edge_type AS edge_type,
	json_build_object(
		'start_position', start_position,
		'pts', pts,
		'team_id', team_id,
		'team_abbreviation', team_abbreviation
	) as properties
FROM deduped
WHERE row_num =1

SELECT player_id, game_id, COUNT(1)
FROM game_details
GROUP BY 1,2

select type, count(1)
from vertices
group by 1