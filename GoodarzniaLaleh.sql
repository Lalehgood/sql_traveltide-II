/*
Question #1: 
Vibestream is designed for users to share brief updates about 
how they are feeling, as such the platform enforces a character limit of 25. 
How many posts are exactly 25 characters long?

Expected column names: char_limit_posts
*/

-- q1 solution:

WITH char_25 AS (
  SELECT COUNT(LENGTH(content)) AS char_limit FROM posts 
  GROUP BY content
  HAVING LENGTH(content)=25)
                      
SELECT SUM(char_limit) AS char_limit_posts FROM char_25; -- replace this with your query

/*

Question #2: 
Users JamesTiger8285 and RobertMermaid7605 are Vibestream’s most active posters.

Find the difference in the number of posts these two users made on each day 
that at least one of them made a post. Return dates where the absolute value of 
the difference between posts made is greater than 2 
(i.e dates where JamesTiger8285 made at least 3 more posts than RobertMermaid7605 or vice versa).

Expected column names: post_date
*/

-- q2 solution:

WITH james AS (
  SELECT users.user_id, post_date, COUNT(content) AS count
  FROM users FULL JOIN posts USING(user_id)
  GROUP BY users.user_id, post_date	HAVING user_name= 'JamesTiger8285'
  ORDER BY COUNT(content) DESC),
  robert AS 
  (SELECT  users.user_id, post_date, COUNT(content) AS count
   FROM users FULL JOIN posts USING(user_id)
   GROUP BY users.user_id, post_date	HAVING user_name= 'RobertMermaid7605'
   ORDER BY COUNT(content) DESC)                    
                       
SELECT post_date
FROM james FULL JOIN robert USING(post_date)
WHERE abs(COALESCE(james.count,0) - COALESCE(robert.count,0))> 2; -- replace this with your query

/*
Question #3: 
Most users have relatively low engagement and few connections. 
User WilliamEagle6815, for example, has only 2 followers.

Network Analysts would say this user has two **1-step path** relationships. 
Having 2 followers doesn’t mean WilliamEagle6815 is isolated, however. 
Through his followers, he is indirectly connected to the larger Vibestream network.  

Consider all users up to 3 steps away from this user:

- 1-step path (X → WilliamEagle6815)
- 2-step path (Y → X → WilliamEagle6815)
- 3-step path (Z → Y → X → WilliamEagle6815)

Write a query to find follower_id of all users within 4 steps of WilliamEagle6815. 
Order by follower_id and return the top 10 records.

Expected column names: follower_id

*/

-- q3 solution:

SELECT DISTINCT f1.follower_id FROM follows AS f1 
FULL JOIN follows AS f2 ON f1.followee_id=f2.follower_id
FULL JOIN follows AS f3 ON f2.followee_id=f3.follower_id
FULL JOIN follows AS f4 ON f3.followee_id=f4.follower_id
WHERE f4.followee_id=(SELECT user_id FROM users WHERE user_name = 'WilliamEagle6815')
ORDER BY follower_id ASC LIMIT 10; -- replace this with your query

/*
Question #4: 
Return top posters for 2023-11-30 and 2023-12-01. 
A top poster is a user who has the most OR second most number of posts 
in a given day. Include the number of posts in the result and 
order the result by post_date and user_id.

Expected column names: post_date, user_id, posts

</aside>
*/

-- q4 solution:

WITH top_rank AS (
  SELECT post_date, user_id, COUNT(post_id) AS posts,
  RANK() OVER (PARTITION BY post_date ORDER BY COUNT(post_id) DESC) AS rank_post
  FROM posts
  WHERE post_date BETWEEN '2023-11-30' AND '2023-12-01'
  GROUP BY post_date , user_id)
SELECT post_date, user_id, posts
FROM top_rank
WHERE rank_post <=3
ORDER BY post_date, user_id ASC; -- replace this with your query