-- INSTAGRAM USER ANALYSIS
-- In this case study we are basically trying to analyse the instagram user behaviour by which we can track how users engage and interact with our app.
-- This is an attempt to derive business insights for mareting , product and development teams. 

USE ig_clone;

-- Let's now look at the details of each table of our dataset
DESCRIBE users;
DESCRIBE photos;
DESCRIBE comments;
DESCRIBE likes;
DESCRIBE follows;
DESCRIBE tags;
DESCRIBE photo_tags;

-- Now let's answer some questions to gain business insights 

-- Q. Find the total number of users data included in our dataset
SELECT COUNT(*) FROM users;



-- Q. Find 5 oldest users of instagram
SELECT username, created_at FROM users
ORDER BY created_at 
LIMIT 5;

  
-- Q. Find top 5 users who have maximum followers
SELECT us.username, COUNT(f.follower_id) as followers
FROM follows as f
INNER JOIN users as us
ON f.followee_id=us.id
GROUP BY us.username
ORDER BY followers DESC;

-- Almost all the users have 77 or 76 followers in our dataset



-- Q. Find the users who have never posted a single photo on instagram
SELECT username FROM users as us
LEFT JOIN photos as ph
ON us.id=ph.user_id
WHERE image_url IS NULL
ORDER BY username;

-- So, 26 out of 100 users from our dataset have never posted any picture on instagram till date.



-- Q. Find the person who has max number of likes on their photo
SELECT username, photo_id, COUNT(lk.user_id ) as likes
FROM likes as lk
INNER JOIN photos as ph
ON lk.photo_id=ph.id
INNER JOIN users as us
ON ph.user_id=us.id
GROUP BY lk.photo_id, us.username
ORDER BY likes DESC
LIMIT 1;

-- We found that 'Zack_Kemmer93' has the maximum (48) likes on his photo



-- Q. Identify and suggest the top 5 most commonly used hashtags
SELECT * FROM photo_tags, tags;

SELECT tag_name, COUNT(photo_id) as hashtag_count
FROM photo_tags as pht
INNER JOIN tags as tg
ON pht.tag_id=tg.id
GROUP BY tg.tag_name
ORDER BY hashtag_count DESC;

-- 'Simle' hashtag is most commonly used by the instagram users.



-- Q. What day of the week do most users register on
SELECT DATE_FORMAT((created_at), '%W') as day, COUNT(id) as user_count
FROM users
GROUP BY day
ORDER BY user_count DESC;

-- So, we saw that most of the users are regestring on instagram on 'Thursday' ans 'Sunday'. So, we can arrange the marketing campaigns on these days more to attract more user registrations. 
-- Also, Saturday, Sunday is weekend is it is obvious that the user registration is increasing on these days.



-- Q. Provide how many times does an average user posts every day. 
-- Also provide the total number of photos on instagram Vs total number of users.
WITH base as(
SELECT us.id as userID, COUNT(ph.id) as photoID
FROM users as us
LEFT JOIN photos as ph 
ON ph.user_id=us.id
GROUP BY us.id)

SELECT SUM(photoID) as Total_photos, 
	COUNT(userID) as Total_users,
	SUM(photoID)/COUNT(userID) as photo_per_user
    FROM base;

-- Total 514 photos were posted by 100 users with an average photo per user rate of 5.14



-- Q. Provide data on users who have liked every single photo on the site.
WITH base as(
	SELECT us.username as username, COUNT(lk.photo_id) as like_count
    FROM likes as lk
    INNER JOIN users as us
    ON us.id=lk.user_id
    GROUP BY us.username)
    
SELECT username, like_count
FROM base
WHERE like_count=(SELECT COUNT(DISTINCT lk.photo_id) FROM likes as lk)
ORDER BY username;

-- Here 13 users have liked each photo uploaded on instagram. This means that these users are basically bots because a user cannot like every single photo.
