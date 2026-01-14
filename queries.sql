-- Query 1: Power Play Point Leaders (Complex Join & Conditional Logic)
-- Objectives: Identify top scorers during man-advantage situations.
SELECT 
    p.first_name, 
    p.last_name, 
    COALESCE(SUM(CASE WHEN g.scorer = p.player_id THEN 1 ELSE 0 END), 0) AS pp_goals, 
    COALESCE(SUM(CASE WHEN g.primary_assist = p.player_id OR g.secondary_assist = p.player_id THEN 1 ELSE 0 END), 0) AS pp_assists, 
    COALESCE(SUM(CASE 
        WHEN g.scorer = p.player_id OR g.primary_assist = p.player_id OR g.secondary_assist = p.player_id 
        THEN 1 ELSE 0 END), 0) AS pp_points 
FROM goals g 
JOIN games gm ON g.game_id = gm.game_id 
JOIN players p ON p.player_id IN (g.scorer, g.primary_assist, g.secondary_assist) 
WHERE 
    ((g.event_owner = gm.home_id AND g.home_skaters > g.away_skaters AND NOT (g.home_skaters = 6 AND g.away_skaters = 5)) 
    OR 
    (g.event_owner = gm.away_id AND g.away_skaters > g.home_skaters AND NOT (g.away_skaters = 6 AND g.home_skaters = 5)))
GROUP BY p.player_id, p.first_name, p.last_name 
ORDER BY pp_points DESC;

-- Query 2: Shooter vs. Goalie Analysis (Aggregated Performance)
-- Objectives: Determine which shooters historically dominate specific goalies.
WITH shooter_shots AS ( 
    SELECT shooter, goalie, COUNT(*) AS shots 
    FROM shots_on_goal 
    GROUP BY shooter, goalie 
), 
shooter_goals AS ( 
    SELECT scorer AS shooter, goalie, COUNT(*) AS goals 
    FROM goals 
    GROUP BY scorer, goalie 
) 
SELECT 
    sp.first_name AS shooter_first, 
    sp.last_name AS shooter_last, 
    gp.first_name AS goalie_first, 
    gp.last_name AS goalie_last, 
    COALESCE(g.goals, 0) AS total_goals 
FROM shooter_shots s 
LEFT JOIN shooter_goals g ON s.shooter = g.shooter AND s.goalie = g.goalie 
JOIN players sp ON s.shooter = sp.player_id 
JOIN players gp ON s.goalie = gp.player_id 
WHERE s.shots > 5 
ORDER BY total_goals DESC;

-- Query 3: Defensive Zone Pressure (Spatial Analysis)
-- Objectives: Identify players most targeted by hits in their own defensive zone.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    COUNT(*) AS times_hit
FROM hits h
INNER JOIN players p ON h.hittee = p.player_id
WHERE h.zone = 'D' -- 'D' denotes Defensive Zone
GROUP BY p.player_id, p.first_name, p.last_name
ORDER BY times_hit DESC;
